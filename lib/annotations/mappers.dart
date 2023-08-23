import 'package:portal/annotations/routing_method.dart';

class GetMapping implements RoutingAnnotation {
  const GetMapping(this.path);

  @override
  final String path;

  @override
  String getMethodAsString() => "GET";
}

class PostMapping implements RoutingAnnotation {
  const PostMapping(this.path);

  @override
  final String path;

  @override
  String getMethodAsString() => "POST";
}

class PutMapping implements RoutingAnnotation {
  const PutMapping(this.path);

  @override
  final String path;

  @override
  String getMethodAsString() => "PUT";
}

class DeleteMapping implements RoutingAnnotation {
  const DeleteMapping(this.path);

  @override
  final String path;

  @override
  String getMethodAsString() => "DELETE";
}
