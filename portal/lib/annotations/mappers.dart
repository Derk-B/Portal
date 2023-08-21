import 'package:portal/annotations/routing_method.dart';

class GetMapping implements RoutingAnnotation {
  const GetMapping(this.path);

  @override
  final String path;
}

class PostMapping implements RoutingAnnotation {
  const PostMapping(this.path);

  @override
  final String path;
}

class PutMapping implements RoutingAnnotation {
  const PutMapping(this.path);

  @override
  final String path;
}

class DeleteMapping implements RoutingAnnotation {
  const DeleteMapping(this.path);

  @override
  final String path;
}
