import 'dart:io';

import 'package:portal/annotations/annotation.dart';
import 'package:portal/core/middleware/middleware.dart';

abstract class MiddlewareAnnotation extends Annotation {
  const MiddlewareAnnotation();

  Middleware<HttpRequest?> process(Function(HttpRequest?) func);
}
