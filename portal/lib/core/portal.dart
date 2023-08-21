import 'dart:io';
import 'dart:mirrors';

import 'package:portal/annotations/mappers.dart';
import 'package:portal/annotations/routing_method.dart';
import 'package:portal/core/routing_templates.dart';

class Portal {
  Portal();

  final Map<String, InstanceMirror> _requestClasses = {};

  MapEntry<String, InstanceMirror> _getRequestClassForPath(String path) {
    return _requestClasses.entries
        .firstWhere((entry) => path.startsWith(entry.key));
  }

  _requestHasCorrectMethod(
      HttpRequest request, RoutingAnnotation routingAnnotation) {
    return switch (request.method) {
      "GET" => routingAnnotation is GetMapping,
      "POST" => routingAnnotation is PostMapping,
      "PUT" => routingAnnotation is PutMapping,
      "DELETE" => routingAnnotation is DeleteMapping,
      _ => false
    };
  }

  _invokeMethodForPath(
      HttpRequest request, String path, InstanceMirror instanceMirror) {
    for (MapEntry<Symbol, MethodMirror> entry in instanceMirror.type.instanceMembers.entries) {
      MethodMirror member = entry.value;
      if (member.isOperator ||
          !member.isRegularMethod ||
          member.owner?.simpleName != instanceMirror.type.simpleName) {
        continue;
      }

      RoutingAnnotation routeAnnotation = member.metadata
          .firstWhere((element) => element.reflectee is RoutingAnnotation)
          .reflectee as RoutingAnnotation;

      if (routeAnnotation.path == path &&
          _requestHasCorrectMethod(request, routeAnnotation)) {
        instanceMirror.invoke(member.simpleName, [request]);
        return;
      }
    }

    return404(request);
  }

  use(String path, Object requestClass) {
    _requestClasses.addEntries({path: reflect(requestClass)}.entries);
  }

  listen(int port) async {
    var server = await HttpServer.bind("localhost", port);

    await for (HttpRequest request in server) {
      MapEntry<String, InstanceMirror> requestClass =
          _getRequestClassForPath(request.uri.toString());

      // Only the remaining part of the uri is needed to match with the methods.
      // So the path that was defined for the class that contains routes, is removed from the uri.
      _invokeMethodForPath(
          request,
          request.uri.toString().replaceFirst(requestClass.key, ''),
          requestClass.value);
    }
  }
}
