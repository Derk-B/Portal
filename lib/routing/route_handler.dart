import 'dart:mirrors';

import 'package:portal/annotations/annotation.dart';

class RouteHandler {
  final MethodMirror methodMirror;
  final InstanceMirror instanceMirror;
  final Annotation routingAnnotation;

  const RouteHandler(
      this.methodMirror, this.instanceMirror, this.routingAnnotation);
}
