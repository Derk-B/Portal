import 'dart:io';

import 'request_handlers.dart';

class RequestHandlerFactory {
  static AbstractRequestHandler createRequestHandler(HttpRequest request) {
    return switch (request.method) {
      "GET" => GetRequestHandler(),
      "POST" => PostRequestHandler(),
      "PUT" => PutRequestHandler(),
      "DELETE" => DeleteRequestHandler(),
      "HEAD" => HeadRequestHandler(),
      "CONNECT" => ConnectRequestHandler(),
      "OPTIONS" => OptionsRequestHandler(),
      "TRACE" => TraceRequestHandler(),
      "PATCH" => PatchRequestHandler(),
      _ => throw Exception("Unsupported request method")
    };
  }
}
