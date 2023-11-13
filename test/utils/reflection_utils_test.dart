import 'dart:mirrors';

import 'package:portal/annotations/routing/mappers.dart';
import 'package:portal/utils/reflection_utils.dart';
import 'package:test/test.dart';

class TestClass {
  const TestClass();

  @GetMapping("/")
  @PostMapping("/save")
  void sum() {}

  void empty() {}
}

void main() {
  test("Should determine that this method is a custom method", () {
    InstanceMirror instanceMirror = reflect(TestClass());
    MethodMirror methodMirror = instanceMirror.type.instanceMembers.entries
        .firstWhere((element) => element.key == Symbol("sum"))
        .value;

    expect(isCustomMethod(methodMirror, instanceMirror), equals(true));
  });

  test("Should determine that this method is not a custom method", () {
    InstanceMirror instanceMirror = reflect(TestClass());
    MethodMirror methodMirror = instanceMirror.type.instanceMembers.entries
        .firstWhere((element) => element.key == Symbol("toString"))
        .value;

    expect(isCustomMethod(methodMirror, instanceMirror), equals(false));
  });

  test("Should return the first annotation for sum method", () {
    InstanceMirror instanceMirror = reflect(TestClass());
    MethodMirror methodMirror = instanceMirror.type.instanceMembers.entries
        .firstWhere((element) => element.key == Symbol("sum"))
        .value;

    expect(getRoutingAnnotation(methodMirror), isA<GetMapping>());
  });

  test("Should return no annotation for empty method", () {
    InstanceMirror instanceMirror = reflect(TestClass());
    MethodMirror methodMirror = instanceMirror.type.instanceMembers.entries
        .firstWhere((element) => element.key == Symbol("empty"))
        .value;

    expect(getRoutingAnnotation(methodMirror), isNull);
  });

  test("Should determine that this method is a routing method", () {
    InstanceMirror instanceMirror = reflect(TestClass());
    MethodMirror methodMirror = instanceMirror.type.instanceMembers.entries
        .firstWhere((element) => element.key == Symbol("sum"))
        .value;

    expect(isRoutingMethod(methodMirror), isTrue);
  });

  test("Should determine that this method is not a routing method", () {
    InstanceMirror instanceMirror = reflect(TestClass());
    MethodMirror methodMirror = instanceMirror.type.instanceMembers.entries
        .firstWhere((element) => element.key == Symbol("empty"))
        .value;

    expect(isRoutingMethod(methodMirror), isFalse);
  });

  test("Should get correct routing path from annotation", () {
    InstanceMirror instanceMirror = reflect(TestClass());
    MethodMirror methodMirror = instanceMirror.type.instanceMembers.entries
        .firstWhere((element) => element.key == Symbol("sum"))
        .value;

    expect(getPathFromMethodMirror(methodMirror), equals("/"));
  });

  test("Should return empty routing path from method without annotation", () {
    InstanceMirror instanceMirror = reflect(TestClass());
    MethodMirror methodMirror = instanceMirror.type.instanceMembers.entries
        .firstWhere((element) => element.key == Symbol("empty"))
        .value;

    expect(getPathFromMethodMirror(methodMirror), equals(""));
  });
}
