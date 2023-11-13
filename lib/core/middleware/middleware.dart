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
