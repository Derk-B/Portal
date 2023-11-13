import 'dart:io';

import 'package:portal/annotations/middleware/middleware_annotation.dart';
import 'package:portal/annotations/routing/mappers.dart';
import 'package:portal/core/middleware/middleware.dart';
import 'package:portal/core/portal.dart';

void main(List<String> arguments) {
  Portal portal = Portal();
  portal.use("/", ProductsAPI());

  portal.listen("localhost", 4201);
}

class Logger extends MiddlewareAnnotation {
  const Logger();

  @override
  Middleware<HttpRequest?> process(Function(HttpRequest?) func) {
    return Middleware((req) {
      print(req?.method);
      return func(req);
    });
  }
}

class Authenticated extends MiddlewareAnnotation {
  const Authenticated();

  bool _checkIfAuthenticated(HttpRequest? req) {
    return false;
  }

  @override
  Middleware<HttpRequest?> process(Function(HttpRequest?) func) {
    return Middleware((r) {
      bool isAuthenticated = _checkIfAuthenticated(r);
      if (!isAuthenticated) {
        r!.response
          ..statusCode = HttpStatus.unauthorized
          ..write("Error: not authenticated")
          ..close();
        return null;
      } else {
        return func(r);
      }
    });
  }
}

class ProductsAPI {
  @Authenticated()
  @Logger()
  @GetMapping("products")
  void getProducts(HttpRequest request) {
    print("Getting products");
    request.response
      ..statusCode = HttpStatus.ok
      ..write("Success")
      ..close();
  }

  @PostMapping("products")
  void addProducts(HttpRequest request) {
    print("Saved multiple products");

    request.response
      ..statusCode = HttpStatus.ok
      ..write("Saved all products")
      ..close();
  }

  @PostMapping("saveproduct")
  void addProduct(HttpRequest request) {
    print("Saving a product");

    request.response
      ..statusCode = HttpStatus.ok
      ..write("Saved")
      ..close();
  }
}
