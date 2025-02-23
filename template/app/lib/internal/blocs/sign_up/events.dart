abstract class SignUpEvent {}

class SignUpEvent_SignUp extends SignUpEvent {
  SignUpEvent_SignUp({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;
}

class SignUpEvent_ResendEmailVerificationLink extends SignUpEvent {
  SignUpEvent_ResendEmailVerificationLink({
    required this.email,
  });

  final String email;
}
