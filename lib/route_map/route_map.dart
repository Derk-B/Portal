import 'dart:mirrors';

/// A Map that contains all the routes and the corresponding methods that need
/// to be invoked when a request is made to that route.
class RouteMap {
  final Map<String, MethodMirror> routeMap = {};

  /// Returns the methodMirror for a route.
  ///
  /// If the route is not present in the
  /// [routeMap], this method will return null.
  MethodMirror? tryFindMethodForRoute(String route) {
    return routeMap[route];
  }

  /// Adds a methodMirror to the [routeMap]
  ///
  /// If there the route was already present in the map,
  /// the old route is overwritten.
  addMethodForRoute(MethodMirror methodMirror, String route) {
    routeMap.update(route, (value) => methodMirror,
        ifAbsent: () => methodMirror);
  }
}
