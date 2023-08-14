sealed class AuthEvent {}

class AuthEvent_SignIn extends AuthEvent {
  AuthEvent_SignIn({
    required this.shouldFail,
  });
  final bool shouldFail;
}

class AuthEvent_SignOut extends AuthEvent {}
