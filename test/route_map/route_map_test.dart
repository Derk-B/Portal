import 'dart:mirrors';

import 'package:portal/route_map/route_map.dart';
import 'package:test/test.dart';

class TestReflectionClass {
  methodToBeReflected() {}
  extraMethod() {}
}

void main() {
  late RouteMap routeMap;
  late MethodMirror methodMirror;

  InstanceMirror instanceMirror = reflect(TestReflectionClass());

  setUp(() {
    routeMap = RouteMap();
    methodMirror = instanceMirror.type.instanceMembers.entries
        .where((element) => element.key == Symbol("methodToBeReflected"))
        .first
        .value;

    routeMap.addMethodForRoute(methodMirror, "/exists");
  });

  test("Return null if route not present in map", () {
    MethodMirror? methodFromMap = routeMap.tryFindMethodForRoute("/");
    expect(methodFromMap, equals(null));
  });

  test("Should return method for route that exists in the route map", () {
    MethodMirror? methodFromMap = routeMap.tryFindMethodForRoute("/exists");
    expect(methodFromMap, equals(methodMirror));
  });

  test("Should add method to map", () {
    String route = "/";
    routeMap.addMethodForRoute(methodMirror, route);

    MethodMirror? methodFromMap = routeMap.tryFindMethodForRoute(route);

    expect(methodFromMap, equals(methodMirror));
  });

  test("Should overwrite existing entry in map", () {
    String route = "/";
    routeMap.addMethodForRoute(methodMirror, route);

    MethodMirror extraMethod = instanceMirror.type.instanceMembers.entries
        .firstWhere((element) => element.key == Symbol("extraMethod"))
        .value;

    routeMap.addMethodForRoute(extraMethod, route);

    MethodMirror? methodFromMap = routeMap.tryFindMethodForRoute(route);

    expect(methodFromMap, equals(extraMethod));
  });
}
