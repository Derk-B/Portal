@GenerateNiceMocks([MockSpec<MethodMirror>(), MockSpec<InstanceMirror>()])
import "dart:mirrors";

import 'package:mockito/annotations.dart';
import "package:portal/annotations/routing/routing_annotation.dart";
import "package:portal/core/middleware/middleware.dart";
import "package:portal/core/request_handlers/request_handlers.dart";
import "package:test/test.dart";

@GenerateNiceMocks([MockSpec<RouteHandler>()])
import "package:portal/routing/route_handler.dart";
@GenerateNiceMocks([MockSpec<HttpRequest>()])
import "dart:io";

import 'request_handler_test.mocks.dart';

void main() {
  late RouteHandler testRouteHandler;
  late HttpRequest testRequest;
  late MethodMirror testMethodMirror;
  late InstanceMirror testInstanceMirror;
  RoutingAnnotation testRoutingAnnotation = GetMapping("test");

  setUp(() {
    testRequest = MockHttpRequest();
    testMethodMirror = MockMethodMirror();
    testInstanceMirror = MockInstanceMirror();

    testRouteHandler = RouteHandler(testMethodMirror, testInstanceMirror,
        Middleware<String>((String str) {}), testRoutingAnnotation);
  });

  test("Test invoking GetRequestHandler", () {
    GetRequestHandler().invoke(testRequest, testRouteHandler);
  });

  test("Test invoking PostRequestHandler", () {
    PostRequestHandler().invoke(testRequest, testRouteHandler);
  });

  test("Test invoking PutRequestHandler", () {
    PutRequestHandler().invoke(testRequest, testRouteHandler);
  });

  test("Test invoking DeleteRequestHandler", () {
    DeleteRequestHandler().invoke(testRequest, testRouteHandler);
  });

  test("Test invoking ConnectRequestHandler", () {
    ConnectRequestHandler().invoke(testRequest, testRouteHandler);
  });

  test("Test invoking HeadRequestHandler", () {
    HeadRequestHandler().invoke(testRequest, testRouteHandler);
  });

  test("Test invoking TraceRequestHandler", () {
    TraceRequestHandler().invoke(testRequest, testRouteHandler);
  });

  test("Test invoking PatchRequestHandler", () {
    PatchRequestHandler().invoke(testRequest, testRouteHandler);
  });

  test("Test invoking OptionsRequestHandler", () {
    OptionsRequestHandler().invoke(testRequest, testRouteHandler);
  });
}
