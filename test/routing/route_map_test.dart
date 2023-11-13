import 'dart:mirrors';

import 'package:portal/annotations/routing/mappers.dart';
import 'package:portal/routing/route_handler.dart';
import 'package:portal/utils/reflection_utils.dart';
import 'package:portal/routing/route_map.dart';
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

  final String requestMethod = "GET";

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
    List<RouteHandler?> handlersFromMap =
        routeMap.tryFindHandlerForRoute("/", requestMethod);
    expect(handlersFromMap, equals(List.empty()));
  });

  test("Should return method for route that exists in the route map", () {
    List<RouteHandler?> handlersFromMap =
        routeMap.tryFindHandlerForRoute("/exists", requestMethod);
    expect(handlersFromMap.map((e) => e?.methodMirror), equals([methodMirror]));
  });

  test("Should add method to map", () {
    String route = "/";
    routeMap.addMethodForRoute(methodMirror, instanceMirror, route);

    List<RouteHandler?> handlersFromMap =
        routeMap.tryFindHandlerForRoute(route, requestMethod);

    expect(handlersFromMap.map((e) => e?.methodMirror), equals([methodMirror]));
  });

  test("Should add entry to map and keep old entry as well", () {
    String route = "/";
    routeMap.addMethodForRoute(methodMirror, instanceMirror, route);

    MethodMirror extraMethod = instanceMirror.type.instanceMembers.entries
        .firstWhere((element) => element.key == Symbol("extraMethod"))
        .value;

    routeMap.addMethodForRoute(extraMethod, instanceMirror, route);

    List<RouteHandler?> handlersFromMap =
        routeMap.tryFindHandlerForRoute(route, requestMethod);

    expect(handlersFromMap.map((e) => e?.methodMirror),
        equals([methodMirror, extraMethod]));
  });
}
