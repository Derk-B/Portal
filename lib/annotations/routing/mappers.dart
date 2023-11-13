import 'package:portal/annotations/routing/routing_annotation.dart';

class GetMapping extends RoutingAnnotation {
  const GetMapping(path) : super(path);

  @override
  String getMethodAsString() => "GET";
}

class PostMapping extends RoutingAnnotation {
  const PostMapping(path) : super(path);

  @override
  String getMethodAsString() => "POST";
}

class PutMapping extends RoutingAnnotation {
  const PutMapping(path) : super(path);

  @override
  String getMethodAsString() => "PUT";
}

class DeleteMapping extends RoutingAnnotation {
  const DeleteMapping(path) : super(path);

  @override
  String getMethodAsString() => "DELETE";
}

class HeadMapping extends RoutingAnnotation {
  const HeadMapping(path) : super(path);

  @override
  String getMethodAsString() => "HEAD";
}

class ConnectMapping extends RoutingAnnotation {
  const ConnectMapping(path) : super(path);

  @override
  String getMethodAsString() => "CONNECT";
}

class OptionsMapping extends RoutingAnnotation {
  const OptionsMapping(path) : super(path);

  @override
  String getMethodAsString() => "OPTIONS";
}

class TraceMapping extends RoutingAnnotation {
  const TraceMapping(path) : super(path);

  @override
  String getMethodAsString() => "TRACE";
}

class PatchMapping extends RoutingAnnotation {
  const PatchMapping(path) : super(path);

  @override
  String getMethodAsString() => "PATCH";
}
