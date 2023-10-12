sealed class SignInEvent {}

class SignInEvent_SignIn extends SignInEvent {
  SignInEvent_SignIn({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;
}

// ATTENTION 1/1
class SignInEvent_SignInWithGoogle extends SignInEvent {}
// ---
