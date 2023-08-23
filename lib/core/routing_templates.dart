import 'dart:io';

import 'package:portal/annotations/routing_method.dart';

return404(HttpRequest request) {
  request.response
    ..statusCode = HttpStatus.notFound
    ..write("404 page not found")
    ..close();
}

return405(HttpRequest request, List<RoutingAnnotation> supportedMethods) {
  request.response
    ..statusCode = HttpStatus.methodNotAllowed
    ..headers.add("allow",
        supportedMethods.map((method) => method.getMethodAsString()).join(", "))
    ..write("405 method not allowed")
    ..close();
}
