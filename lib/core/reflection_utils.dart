import 'dart:mirrors';

import 'package:portal/annotations/routing_method.dart';

/// Checks if the method is a custom method written by the user and not a
/// default method like toString or an operator.
bool isCustomMethod(MethodMirror methodMirror, InstanceMirror parent) {
  return methodMirror.isRegularMethod &&
      !methodMirror.isOperator &&
      methodMirror.owner?.simpleName == parent.type.simpleName;
}

/// Returns the RoutingAnnotation for the [methodMirror]
///
/// Only returns the first RoutingAnnotation that is can find.
/// So if another RoutingAnnotation was added to the method, it will be ignored.
///
/// Example:
/// ``` Dart
/// @GetMapping("/")
/// @PostMapping("/next")
/// getPage(HttpRequest request) {
///   ...
/// }
/// ```
///
/// The `@PostMapping("/next")` is ignored in this case.
RoutingAnnotation? getRoutingAnnotation(MethodMirror methodMirror) {
  return methodMirror.metadata
      .cast<InstanceMirror?>()
      .firstWhere(
        (element) => element?.reflectee is RoutingAnnotation,
        orElse: () => null,
      )
      ?.reflectee as RoutingAnnotation?;
}

/// Determines if a method contains a RoutingAnnotation
bool isRoutingMethod(MethodMirror methodMirror) {
  return methodMirror.metadata.any((element) => element is RoutingAnnotation);
}

/// Returns the path from the RoutingAnnotation
String _getPathFromAnnotation(RoutingAnnotation annotation) {
  return annotation.path;
}

String getPathFromMethodMirror(MethodMirror methodMirror) {
  RoutingAnnotation? annotation = getRoutingAnnotation(methodMirror);

  if (annotation == null) return "";

  return _getPathFromAnnotation(annotation);
}
