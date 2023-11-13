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
    print('executing');
    return _value(input);
  }
}

void main() {
  Middleware middleWare = Middleware((str) => print(str));

  middleWare = middleWare
      .bind((input) => Middleware((str) {
            print("1");
            return input("${str}2");
          }))
      .bind((x) => Middleware((str) {
            print("2");
            return null;
          }));

  print("executing..");
  var res = middleWare.execute("test");
  print(res);
}
