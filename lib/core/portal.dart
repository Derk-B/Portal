import 'dart:io';
import 'dart:mirrors';

import 'package:portal/annotations/mappers.dart';
import 'package:portal/annotations/routing_method.dart';
import 'package:portal/core/request_handlers/abstract_request_handler.dart';
import 'package:portal/core/request_handlers/connect_request_handler.dart';
import 'package:portal/core/request_handlers/delete_request_handler.dart';
import 'package:portal/core/request_handlers/get_request_handler.dart';
import 'package:portal/core/request_handlers/head_request_handler.dart';
import 'package:portal/core/request_handlers/options_request_handler.dart';
import 'package:portal/core/request_handlers/patch_request_handler.dart';
import 'package:portal/core/request_handlers/post_request_handler.dart';
import 'package:portal/core/request_handlers/put_request_handler.dart';
import 'package:portal/core/request_handlers/trace_request_handler.dart';
import 'package:portal/core/routing_templates.dart';
import 'package:portal/routing/route_handler.dart';
import 'package:portal/routing/route_map.dart';
import 'package:collection/collection.dart';

class Portal {
  Portal();

  final RouteMap _routeMap = RouteMap();

  AbstractRequestHandler _getRequestHandler(HttpRequest request) {
    return switch (request.method) {
      "GET" => GetRequestHandler(),
      "POST" => PostRequestHandler(),
      "PUT" => PutRequestHandler(),
      "DELETE" => DeleteRequestHandler(),
      "HEAD" => HeadRequestHandler(),
      "CONNECT" => ConnectRequestHandler(),
      "OPTIONS" => OptionsRequestHandler(),
      "TRACE" => TraceRequestHandler(),
      "PATCH" => PatchRequestHandler(),
      _ => throw Exception("Unsupported request method")
    };
  }

  bool _requestHasCorrectMethod(
      HttpRequest request, List<RoutingAnnotation> routingAnnotations) {
    return switch (request.method) {
      "GET" => routingAnnotations.any(
          (annotation) => annotation is GetMapping,
        ),
      "POST" => routingAnnotations.any(
          (annotation) => annotation is PostMapping,
        ),
      "PUT" => routingAnnotations.any(
          (annotation) => annotation is PutMapping,
        ),
      "DELETE" => routingAnnotations.any(
          (annotation) => annotation is DeleteMapping,
        ),
      "HEAD" => routingAnnotations.any(
          (annotation) => annotation is HeadMapping,
        ),
      "CONNECT" => routingAnnotations.any(
          (annotation) => annotation is ConnectMapping,
        ),
      "OPTIONS" => routingAnnotations.any(
          (annotation) => annotation is OptionsMapping,
        ),
      "TRACE" => routingAnnotations.any(
          (annotation) => annotation is TraceMapping,
        ),
      "PATCH" => routingAnnotations.any(
          (annotation) => annotation is PatchMapping,
        ),
      _ => false
    };
  }

  RouteHandler? _getRouteHandlerForMethod(
      HttpRequest request, List<RouteHandler?> routeHandlers) {
    return routeHandlers.firstWhereOrNull((element) =>
        element?.routingAnnotation.getMethodAsString() == request.method);
  }

  _invokeMethodForPath(HttpRequest request, String path) {
    List<RouteHandler?> routeHandlers =
        _routeMap.tryFindHandlerForRoute(path, request.method);

    if (routeHandlers.isEmpty) {
      return404(request);
      return;
    }

    RouteHandler? routeHandler =
        _getRouteHandlerForMethod(request, routeHandlers);

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

    AbstractRequestHandler requestHandler = _getRequestHandler(request);

    requestHandler.invoke(request, routeHandler, instanceMirror);
  }

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
}
