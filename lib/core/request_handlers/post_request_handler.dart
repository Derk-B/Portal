import 'dart:io';

import 'package:portal/core/request_handlers/abstract_request_handler.dart';
import 'package:portal/routing/route_handler.dart';

class PostRequestHandler implements AbstractRequestHandler {
  @override
  void invoke(
    HttpRequest request,
    RouteHandler routeHandler,
  ) {
    routeHandler.instanceMirror
        .invoke(routeHandler.methodMirror.simpleName, [request]);
  }
}
