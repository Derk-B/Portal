import 'dart:io';

import 'package:portal/routing/route_handler.dart';

/// Object that invokes the correct method for a request.
///
/// Is created when Portal has found the correct requestHandler for a request.
abstract class AbstractRequestHandler {
  void invoke(
    HttpRequest request,
    RouteHandler routeHandler,
  );
}
