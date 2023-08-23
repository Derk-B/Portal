import 'dart:io';
import 'dart:mirrors';

import 'package:portal/annotations/mappers.dart';
import 'package:portal/annotations/routing_method.dart';
import 'package:portal/core/request_handlers/abstract_request_handler.dart';
import 'package:portal/core/request_handlers/delete_request_handler.dart';
import 'package:portal/core/request_handlers/get_request_handler.dart';
import 'package:portal/core/request_handlers/post_request_handler.dart';
import 'package:portal/core/request_handlers/put_request_handler.dart';
import 'package:portal/core/routing_templates.dart';
import 'package:portal/routing/route_handler.dart';
import 'package:portal/routing/route_map.dart';

class Portal {
  Portal();

  final RouteMap _routeMap = RouteMap();

  AbstractRequestHandler _getRequestHandler(HttpRequest request) {
    return switch (request.method) {
      "GET" => GetRequestHandler(),
      "POST" => PostRequestHandler(),
      "PUT" => PutRequestHandler(),
      "DELETE" => DeleteRequestHandler(),
      _ => throw Exception("Unsupported request method")
    };
  }

  bool _requestHasCorrectMethod(
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

    AbstractRequestHandler requestHandler = _getRequestHandler(request);

    requestHandler.invoke(request, routeHandler, instanceMirror);
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
