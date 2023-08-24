import 'dart:io';
import 'dart:mirrors';

import 'package:portal/core/request_handlers/abstract_request_handler.dart';
import 'package:portal/routing/route_handler.dart';

class HeadRequestHandler implements AbstractRequestHandler {
  @override
  void invoke(
    HttpRequest request,
    RouteHandler routeHandler,
    InstanceMirror instanceMirror,
  ) {
    instanceMirror.invoke(routeHandler.methodMirror.simpleName, [request]);
  }
}
