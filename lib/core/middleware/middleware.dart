typedef RequestState = String;
typedef Handler<T> = Function(T);

// Monad structure for the middleware.
class Middleware<T> {
  final Handler<T> _value;

  Middleware(this._value);

  Middleware<T> bind(Middleware<T> Function(Handler<T> input) func) {
    return func(_value);
  }

  T execute(T input) {
    return _value(input);
  }
}
