sealed class ResetPasswordEvent {}

class ResetPasswordEvent_ResetPassword extends ResetPasswordEvent {
  ResetPasswordEvent_ResetPassword({
    required this.password,
  });

  final String password;
}
