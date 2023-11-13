import 'package:portal/annotations/annotation.dart';

abstract class RoutingAnnotation extends Annotation {
  const RoutingAnnotation(this.path);
  final String path;

  String getMethodAsString();
}
