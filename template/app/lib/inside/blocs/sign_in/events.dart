abstract class SignIn_Event {}

class SignIn_Event_SignIn extends SignIn_Event {
  SignIn_Event_SignIn({required this.email, required this.password});

  final String email;
  final String password;
}
