import 'dart:io';

// typedef Middleware = Handler Function(Handler);

// Middleware createMiddleware(Handler handler) {
//   return (Handler innerHandler) {
//     return (handler) {
//       return handler.
//     };
//   };
// }

// Middleware addMiddleware(Middleware other) {
//   return (Handler handler) { return other(handler); };
// }

typedef RequestState = String;
typedef Handler<T> = Function(T);

// Monad structure for the middleware.
class MiddleWare<T> {
  final Handler<T> _value;

  MiddleWare(this._value);

  MiddleWare bind(MiddleWare Function(Handler<T> input) func) {
    return func(_value);
  }

  void execute(T input) {
    _value(input);
  }
}

void main() {
  MiddleWare middleWare = MiddleWare((str) => print(str));

  middleWare = middleWare
      .bind((input) => MiddleWare((str) => input("${str}2")))
      .bind((x) => MiddleWare((str) => x("${str}3")));
  middleWare.execute("test");
}
