import 'dart:io';
import 'dart:mirrors';

import 'package:collection/collection.dart';
import 'package:portal/annotations/middleware/middleware_annotation.dart';
import 'package:portal/annotations/routing/routing_annotation.dart';
import 'package:portal/core/middleware/middleware.dart';
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

  /// Creates middleware using all middleware annotations for a method.
  Middleware<HttpRequest?> _createMiddleWare(MethodMirror methodMirror) {
    Iterable<MiddlewareAnnotation> middleWareAnnontations = methodMirror
        .metadata
        .cast<InstanceMirror?>()
        .where((element) => element?.reflectee is MiddlewareAnnotation)
        .map((e) => e?.reflectee as MiddlewareAnnotation?)
        .whereNotNull();

    Middleware<HttpRequest?> middleware = Middleware((req) {
      print("req");
      return req;
    });

    for (MiddlewareAnnotation annotation in middleWareAnnontations) {
      middleware = middleware.bind((req) => annotation.process(req));
    }

    return middleware;
  }

  /// Adds a methodMirror to the [routeMap]
  ///
  /// If there the route was already present in the map,
  /// the old route is overwritten.
  void addMethodForRoute(
      MethodMirror methodMirror, InstanceMirror instanceMirror, String route) {
    RoutingAnnotation? routingAnnotation = getRoutingAnnotation(methodMirror);

    if (routingAnnotation == null) return;

    print("Creating middleware");
    Middleware<HttpRequest?> middleWare = _createMiddleWare(methodMirror);

    RouteHandler routeHandler = RouteHandler(
      methodMirror,
      instanceMirror,
      middleWare,
      routingAnnotation,
    );

    routeMap.update(route, (value) => value + [routeHandler],
        ifAbsent: () => [routeHandler]);
  }

  /// Adds each routing method of the [instanceMirror] to the [routeMap]
  addClassMethods(String path, InstanceMirror instanceMirror) {
    Iterable<MapEntry<Symbol, MethodMirror>> symbolAndMethodEntries =
        instanceMirror.type.instanceMembers.entries;

    // Filter for custom annotations
    Iterable<MapEntry<Symbol, MethodMirror>> customEntries =
        symbolAndMethodEntries
            .where((element) => isCustomMethod(element.value, instanceMirror));

    for (MapEntry<Symbol, MethodMirror> entry in customEntries) {
      addMethodForRoute(entry.value, instanceMirror,
          path + getPathFromMethodMirror(entry.value));
    }
  }
}
