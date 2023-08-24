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

class HeadMapping implements RoutingAnnotation {
  const HeadMapping(this.path);

  @override
  final String path;

  @override
  String getMethodAsString() => "HEAD";
}

class ConnectMapping implements RoutingAnnotation {
  const ConnectMapping(this.path);

  @override
  final String path;

  @override
  String getMethodAsString() => "CONNECT";
}

class OptionsMapping implements RoutingAnnotation {
  const OptionsMapping(this.path);

  @override
  final String path;

  @override
  String getMethodAsString() => "OPTIONS";
}

class TraceMapping implements RoutingAnnotation {
  const TraceMapping(this.path);

  @override
  final String path;

  @override
  String getMethodAsString() => "TRACE";
}

class PatchMapping implements RoutingAnnotation {
  const PatchMapping(this.path);

  @override
  final String path;

  @override
  String getMethodAsString() => "PATCH";
}
