import 'dart:mirrors';

import 'package:portal/annotations/routing_method.dart';

class RouteHandler {
  final MethodMirror methodMirror;
  final InstanceMirror instanceMirror;
  final RoutingAnnotation routingAnnotation;

  const RouteHandler(
      this.methodMirror, this.instanceMirror, this.routingAnnotation);
}
