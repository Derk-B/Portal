import 'dart:io';

import 'package:portal/annotations/middleware/auth/authenticate_annotation.dart';
import 'package:portal/annotations/routing/mappers.dart';
import 'package:portal/core/portal.dart';

void main(List<String> arguments) {
  Portal portal = Portal();
  portal.use("/", ProductsAPI());

  portal.listen("localhost", 4201);
}

class ProductsAPI {
  @Authenticated()
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
