sealed class SignUpEvent {}

class SignUpEvent_SignUp extends SignUpEvent {
  SignUpEvent_SignUp({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;
}
