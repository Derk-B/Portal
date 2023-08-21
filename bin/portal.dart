import 'dart:io';

import 'package:portal/annotations/mappers.dart';
import 'package:portal/core/portal.dart';

void main(List<String> arguments) {
  Portal portal = Portal();
  portal.use("/", ProductsAPI());

  portal.listen(4200);
}

class ProductsAPI {
  @GetMapping("products")
  void getProducts(HttpRequest request) {
    print("Getting products");
    request.response
      ..statusCode = HttpStatus.ok
      ..write("Success")
      ..close();
  }

  @PostMapping("saveproduct")
  void addProduct(HttpRequest request) {
    print("Saving a product");
  }
}
