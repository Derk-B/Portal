import 'dart:io';

import 'package:portal/annotations/routing/routing_annotation.dart';

class TestClass {
  @GetMapping("test")
  void TestMethod(HttpRequest request) {}
}
