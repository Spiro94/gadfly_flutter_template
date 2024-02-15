sealed class ForgotPasswordEvent {}

class ForgotPasswordEvent_ForgotPassword extends ForgotPasswordEvent {
  ForgotPasswordEvent_ForgotPassword({
    required this.email,
  });

  final String email;
}

class ForgotPasswordEvent_ResendForgotPassword extends ForgotPasswordEvent {
  ForgotPasswordEvent_ResendForgotPassword({
    required this.email,
  });

  final String email;
}
