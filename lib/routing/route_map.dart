import 'dart:mirrors';

import 'package:portal/annotations/routing/routing_annotation.dart';
import 'package:portal/utils/reflection_utils.dart';
import 'package:portal/routing/route_handler.dart';

/// A Map that contains all the routes and the corresponding methods that need
/// to be invoked when a request is made to that route.
class RouteMap {
  final Map<String, List<RouteHandler>> routeMap = {};

  /// Returns the RouteHandler for a route.
  ///
  /// If the route is not present in the
  /// [routeMap], this method will return an empty list.
  List<RouteHandler?> tryFindHandlerForRoute(String route, String method) {
    List<RouteHandler?>? routeHandlers = routeMap[route];

    if (routeHandlers == null) return List.empty();

    return routeHandlers;
  }

  /// Adds a methodMirror to the [routeMap]
  ///
  /// If there the route was already present in the map,
  /// the old route is overwritten.
  addMethodForRoute(
      MethodMirror methodMirror, InstanceMirror instanceMirror, String route) {
    RoutingAnnotation? annotation = getRoutingAnnotation(methodMirror);

    if (annotation == null) return;

    RouteHandler routeHandler =
        RouteHandler(methodMirror, instanceMirror, annotation);

    routeMap.update(route, (value) => value + [routeHandler],
        ifAbsent: () => [routeHandler]);
  }

  /// Adds each routing method of the [instanceMirror] to the [routeMap]
  addClassMethods(String path, InstanceMirror instanceMirror) {
    Iterable<MapEntry<Symbol, MethodMirror>> symbolAndMethodEntries =
        instanceMirror.type.instanceMembers.entries;

    for (MapEntry<Symbol, MethodMirror> entry in symbolAndMethodEntries) {
      if (!isCustomMethod(entry.value, instanceMirror)) continue;

      addMethodForRoute(entry.value, instanceMirror,
          path + getPathFromMethodMirror(entry.value));
    }
  }
}
