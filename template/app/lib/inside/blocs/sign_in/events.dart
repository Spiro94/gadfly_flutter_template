abstract class SignInEvent {}

class SignInEvent_SignIn extends SignInEvent {
  SignInEvent_SignIn({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;
}
