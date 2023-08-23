import 'dart:mirrors';

import 'package:portal/annotations/mappers.dart';
import 'package:portal/core/reflection_utils.dart';
import 'package:portal/route_map/route_map.dart';
import 'package:test/test.dart';

class TestReflectionClass {
  @GetMapping("/exists")
  methodToBeReflected() {}

  @GetMapping("/extra")
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

    String path = getPathFromMethodMirror(methodMirror);

    routeMap.addMethodForRoute(methodMirror, instanceMirror, path);
  });

  test("Return null if route not present in map", () {
    RouteHandler? handlerFromMap = routeMap.tryFindHandlerForRoute("/");
    expect(handlerFromMap, equals(null));
  });

  test("Should return method for route that exists in the route map", () {
    RouteHandler? handlerFromMap = routeMap.tryFindHandlerForRoute("/exists");
    expect(handlerFromMap?.methodMirror, equals(methodMirror));
  });

  test("Should add method to map", () {
    String route = "/";
    routeMap.addMethodForRoute(methodMirror, instanceMirror, route);

    RouteHandler? handlerFromMap = routeMap.tryFindHandlerForRoute(route);

    expect(handlerFromMap?.methodMirror, equals(methodMirror));
  });

  test("Should overwrite existing entry in map", () {
    String route = "/";
    routeMap.addMethodForRoute(methodMirror, instanceMirror, route);

    MethodMirror extraMethod = instanceMirror.type.instanceMembers.entries
        .firstWhere((element) => element.key == Symbol("extraMethod"))
        .value;

    routeMap.addMethodForRoute(extraMethod, instanceMirror, route);

    RouteHandler? handlerFromMap = routeMap.tryFindHandlerForRoute(route);

    expect(handlerFromMap?.methodMirror, equals(extraMethod));
  });
}
