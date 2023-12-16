import 'package:portal/core/middleware/middleware.dart';
import 'package:test/test.dart';

void main() {
  test("Should execute a chain of functions", () {
    Middleware<String> middleware = Middleware((String str) => "${str}world!");
    middleware = middleware.bind((func) => Middleware((str) => func("$str ")));
    String value = middleware.execute("Hello");

    expect(value, equals("Hello world!"));
  });
}
