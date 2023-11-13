import 'package:portal/annotations/annotation.dart';

class AuthenticateAnnotation extends Annotation {
  const AuthenticateAnnotation();
}

class Authenticated extends AuthenticateAnnotation {
  const Authenticated();
}

class Anonymous extends AuthenticateAnnotation {
  const Anonymous();
}
