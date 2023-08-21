import 'dart:io';

return404(HttpRequest request) {
    request.response
      ..statusCode = HttpStatus.notFound
      ..write("404 page not found")
      ..close();
}