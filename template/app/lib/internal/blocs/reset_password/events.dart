abstract class ResetPasswordEvent {}

class ResetPasswordEvent_SendResetPasswordLink extends ResetPasswordEvent {
  ResetPasswordEvent_SendResetPasswordLink({
    required this.email,
  });

  final String email;
}

class ResetPasswordEvent_ResendResetPasswordLink extends ResetPasswordEvent {
  ResetPasswordEvent_ResendResetPasswordLink({
    required this.email,
  });

  final String email;
}

class ResetPasswordEvent_ResetPassword extends ResetPasswordEvent {
  ResetPasswordEvent_ResetPassword({
    required this.password,
  });

  final String password;
}
