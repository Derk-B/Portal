import 'dart:mirrors';

import 'package:portal/annotations/routing/routing_annotation.dart';
import 'package:portal/core/middleware/middleware.dart';

/// Object that stores information for processing a request to a certain path.
class RouteHandler {
  final MethodMirror methodMirror;
  final InstanceMirror instanceMirror;
  final Middleware middleWare;
  final RoutingAnnotation routingAnnotation;

  const RouteHandler(
    this.methodMirror,
    this.instanceMirror,
    this.middleWare,
    this.routingAnnotation,
  );
}
