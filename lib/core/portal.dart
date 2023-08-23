import 'dart:io';
import 'dart:mirrors';

import 'package:portal/annotations/mappers.dart';
import 'package:portal/annotations/routing_method.dart';
import 'package:portal/core/routing_templates.dart';
import 'package:portal/route_map/route_map.dart';

class Portal {
  Portal();

  final RouteMap _routeMap = RouteMap();

  _requestHasCorrectMethod(
      HttpRequest request, RoutingAnnotation routingAnnotation) {
    return switch (request.method) {
      "GET" => routingAnnotation is GetMapping,
      "POST" => routingAnnotation is PostMapping,
      "PUT" => routingAnnotation is PutMapping,
      "DELETE" => routingAnnotation is DeleteMapping,
      _ => false
    };
  }

  _invokeMethodForPath(HttpRequest request, String path) {
    RouteHandler? routeHandler = _routeMap.tryFindHandlerForRoute(path);

    if (routeHandler == null) {
      return404(request);
      return;
    }

    InstanceMirror? instanceMirror = routeHandler.instanceMirror;

    if (!_requestHasCorrectMethod(request, routeHandler.routingAnnotation)) {
      return405(request);
      return;
    }

    instanceMirror.invoke(routeHandler.methodMirror.simpleName, [request]);
  }

  use(String path, Object requestClass) {
    _routeMap.addClassMethods(path, reflect(requestClass));
  }

  listen(int port) async {
    var server = await HttpServer.bind("localhost", port);

    await for (HttpRequest request in server) {
      // Only the remaining part of the uri is needed to match with the methods.
      // So the path that was defined for the class that contains routes, is removed from the uri.
      _invokeMethodForPath(request, request.uri.toString());
    }
  }
}
