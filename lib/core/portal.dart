import 'dart:io';
import 'dart:mirrors';

import 'package:portal/annotations/routing/routing_annotation.dart';
import 'package:portal/core/request_handlers/request_handlers.dart';
import 'package:portal/core/routing_templates.dart';
import 'package:portal/routing/route_handler.dart';
import 'package:portal/routing/route_map.dart';
import 'package:collection/collection.dart';

class Portal {
  Portal();

  final RouteMap _routeMap = RouteMap();

  bool _requestHasCorrectMethod(
    HttpRequest request,
    List<RoutingAnnotation> routingAnnotations,
  ) {
    return routingAnnotations.any(
      (element) => element.isCorrectMethod(request),
    );
  }

  RouteHandler? _getRouteHandlerForMethod(
    HttpRequest request,
    List<RouteHandler?> routeHandlers,
  ) {
    return routeHandlers.firstWhereOrNull((element) =>
        element?.routingAnnotation.getMethodAsString() == request.method);
  }

  /// Invoke the method for the path by looking up the correct routeHandler
  ///
  /// Also takes care of some errors in 404 and 405 situations
  ///
  /// TODO: move errorhandling to somewhere else.
  _invokeMethodForPath(HttpRequest request, String path) {
    // Get all routeHandlers for this path
    List<RouteHandler?> routeHandlers =
        _routeMap.tryFindHandlerForRoute(path, request.method);

    // Return 404 if there are no handlers for this route.
    if (routeHandlers.isEmpty) {
      return404(request);
      return;
    }

    // Get the routeHandler for this specific type of request.
    RouteHandler? routeHandler =
        _getRouteHandlerForMethod(request, routeHandlers);

    // If there is not routeHandler for this type of request then return 405.
    if (routeHandler == null) {
      routeHandlers.removeWhere((handler) => handler == null);
      return405(
        request,
        routeHandlers.map((e) => e!.routingAnnotation).toList(),
      );
      return;
    }

    InstanceMirror? instanceMirror = routeHandler.instanceMirror;

    if (!_requestHasCorrectMethod(request, [routeHandler.routingAnnotation])) {
      return405(request, [routeHandler.routingAnnotation]);
      return;
    }

    AbstractRequestHandler requestHandler =
        RequestHandlerFactory.createRequestHandler(request);

    requestHandler.invoke(request, routeHandler, instanceMirror);
  }

  /// Generate routes.
  ///
  /// Add routes of the [requestClass] to the [_routeMap].
  /// Add middleware to the roues.
  use(String path, Object requestClass) {
    _routeMap.addClassMethods(path, reflect(requestClass));
  }

  listen(String address, int port) async {
    var server = await HttpServer.bind(address, port);

    await for (HttpRequest request in server) {
      // Only the remaining part of the uri is needed to match with the methods.
      // So the path that was defined for the class that contains routes, is removed from the uri.
      _invokeMethodForPath(request, request.uri.toString());
    }
  }

  addMiddleware() {}
}
