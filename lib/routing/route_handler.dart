import 'dart:mirrors';

import 'package:portal/annotations/routing/routing_annotation.dart';
import 'package:portal/core/middleware/middleware.dart';

class RouteHandler {
  final MethodMirror methodMirror;
  final InstanceMirror instanceMirror;
  final MiddleWare middleWare;
  final RoutingAnnotation routingAnnotation;

  const RouteHandler(
    this.methodMirror,
    this.instanceMirror,
    this.middleWare,
    this.routingAnnotation,
  );
}
