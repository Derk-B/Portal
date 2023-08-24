# Portal
A dart library for creating API routes using annotations

## Manual

There is an example located in `/bin/portal.dart`

This is how to use portal.

First you create a class that will contain methods that will process the requests.
You can define methods for processing http request using a RoutingAnnotation, like `GetMapping("/")` or `PostMapping("/")`

The paramater of the RoutinAnnotation contains the route that this method will listen to.

Add an HttpRequest object as parameter of the method and use this to process the request, as shown below.

```dart
// myapp/bin/products_api.dart
import 'dart:io';

import 'package:portal/annotations/mappers.dart';

class ProductsAPI {
  @GetMapping("products")
  void getProducts(HttpRequest request) {
    request.response
      ..statusCode = HttpStatus.ok
      ..write("[product1, product2]")
      ..close();
  }
}
```

How tell portal to use the `ProductsApi` class. You can do this using the `use` method, where you need to define a path that will serve as a prefix of the total uri for this class.

```dart
// myapp/bin/myapp.dart
import 'package:portal/core/portal.dart';
import 'products_api.dart';

void main(List<String> arguments) {
  Portal portal = Portal();
  portal.use("/", ProductsAPI());
}
```

To run portal use `listen(String address, int port)` method and specify the address and port where portal should listen.

Below is an example where portal listens to `http://localhost:8080`

```dart
Portal portal = Portal();
portal.listen("localhost", 8080);
```

Now your code should like this:

```dart
// myapp/bin/myapp.dart
import 'dart:io';

import 'package:portal/annotations/mappers.dart';
import 'package:portal/core/portal.dart';

void main(List<String> arguments) {
  Portal portal = Portal();
  portal.use("/", ProductsAPI());

  portal.listen("localhost", 8080);
}

class ProductsAPI {
  @GetMapping("products")
  void getProducts(HttpRequest request) {
    print("Getting products");
    request.response
      ..statusCode = HttpStatus.ok
      ..write("[product1, product2]")
      ..close();
  }
}
```

If you now visit `http://localhost:8080/products` inside your browser, it should return some plain text saying: `[product1, product2]`
