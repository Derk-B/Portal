import 'dart:io';

import 'package:portal/annotations/middleware/middleware_annotation.dart';
import 'package:portal/core/middleware/middleware.dart';

abstract class AuthenticateAnnotation extends MiddlewareAnnotation {
  const AuthenticateAnnotation();

  @override
  Middleware<HttpRequest?> process(Function(HttpRequest?) func);
}

class Authenticated extends AuthenticateAnnotation {
  const Authenticated();

  bool _checkIfAuthenticated(HttpRequest? req) {
    return true;
  }

  @override
  Middleware<HttpRequest?> process(Function(HttpRequest?) func) {
    print("building middlware atuhenticated");
    return Middleware((r) {
      print("Checking if request is authenticated");
      bool isAuthenticated = _checkIfAuthenticated(r);
      if (!isAuthenticated) {
        r!.response
          ..statusCode = HttpStatus.unauthorized
          ..write("Error: not authenticated")
          ..close();
        return null;
      } else {
        print("else");
        return func(r);
      }
    });
  }
}

class Anonymous extends AuthenticateAnnotation {
  const Anonymous();

  @override
  Middleware<HttpRequest> process(Function(HttpRequest) func) {
    return Middleware((r) => func(r));
  }
}
