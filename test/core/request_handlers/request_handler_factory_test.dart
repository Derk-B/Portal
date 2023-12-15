@GenerateNiceMocks([MockSpec<HttpRequest>()])
import 'dart:io';

import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:portal/core/request_handlers/request_handlers.dart';
import 'package:test/test.dart';

import 'request_handler_test.mocks.dart';

void main() {
  test("Test creation of GET request handler", () {
    HttpRequest request = MockHttpRequest();
    when(request.method).thenReturn("GET");

    AbstractRequestHandler requestHandler =
        RequestHandlerFactory.createRequestHandler(request);

    expect(requestHandler.runtimeType, equals(GetRequestHandler));
  });

  test("Test creation of POST request handler", () {
    MockHttpRequest request = MockHttpRequest();
    when(request.method).thenReturn("POST");

    AbstractRequestHandler requestHandler =
        RequestHandlerFactory.createRequestHandler(request);

    expect(requestHandler.runtimeType, equals(PostRequestHandler));
  });

  test("Test creation of PUT request handler", () {
    MockHttpRequest request = MockHttpRequest();
    when(request.method).thenReturn("PUT");

    AbstractRequestHandler requestHandler =
        RequestHandlerFactory.createRequestHandler(request);

    expect(requestHandler.runtimeType, equals(PutRequestHandler));
  });

  test("Test creation of DELETE request handler", () {
    MockHttpRequest request = MockHttpRequest();
    when(request.method).thenReturn("DELETE");

    AbstractRequestHandler requestHandler =
        RequestHandlerFactory.createRequestHandler(request);

    expect(requestHandler.runtimeType, equals(DeleteRequestHandler));
  });

  test("Test creation of PATCH request handler", () {
    MockHttpRequest request = MockHttpRequest();
    when(request.method).thenReturn("PATCH");

    AbstractRequestHandler requestHandler =
        RequestHandlerFactory.createRequestHandler(request);

    expect(requestHandler.runtimeType, equals(PatchRequestHandler));
  });

  test("Test creation of OPTIONS request handler", () {
    MockHttpRequest request = MockHttpRequest();
    when(request.method).thenReturn("OPTIONS");

    AbstractRequestHandler requestHandler =
        RequestHandlerFactory.createRequestHandler(request);

    expect(requestHandler.runtimeType, equals(OptionsRequestHandler));
  });

  test("Test creation of HEAD request handler", () {
    MockHttpRequest request = MockHttpRequest();
    when(request.method).thenReturn("HEAD");

    AbstractRequestHandler requestHandler =
        RequestHandlerFactory.createRequestHandler(request);

    expect(requestHandler.runtimeType, equals(HeadRequestHandler));
  });

  test("Test creation of TRACE request handler", () {
    MockHttpRequest request = MockHttpRequest();
    when(request.method).thenReturn("TRACE");

    AbstractRequestHandler requestHandler =
        RequestHandlerFactory.createRequestHandler(request);

    expect(requestHandler.runtimeType, equals(TraceRequestHandler));
  });

  test("Test creation of CONNECT request handler", () {
    MockHttpRequest request = MockHttpRequest();
    when(request.method).thenReturn("CONNECT");

    AbstractRequestHandler requestHandler =
        RequestHandlerFactory.createRequestHandler(request);

    expect(requestHandler.runtimeType, equals(ConnectRequestHandler));
  });

  test("Should throw exception on invalid request method", () {
    MockHttpRequest request = MockHttpRequest();
    when(request.method).thenReturn("SOME_INVALID_METHOD");

    expect(() => RequestHandlerFactory.createRequestHandler(request),
        throwsA(TypeMatcher<Exception>()));
  });
}
