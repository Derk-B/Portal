import 'dart:io';

import 'package:portal/annotations/annotation.dart';

export 'mappers.dart';

abstract class RoutingAnnotation extends Annotation {
  const RoutingAnnotation(this.path);
  final String path;

  String getMethodAsString();

  bool isCorrectMethod(HttpRequest request) {
    return request.method == getMethodAsString();
  }
}
