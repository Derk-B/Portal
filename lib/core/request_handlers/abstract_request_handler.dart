import 'dart:io';
import 'dart:mirrors';

import 'package:portal/routing/route_handler.dart';

abstract class AbstractRequestHandler {
  void invoke(
    HttpRequest request,
    RouteHandler routeHandler,
    InstanceMirror instanceMirror,
  );
}
