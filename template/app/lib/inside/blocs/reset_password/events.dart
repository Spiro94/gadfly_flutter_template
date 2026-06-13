abstract class ResetPassword_Event {}

class ResetPassword_Event_SendResetPasswordLink extends ResetPassword_Event {
  ResetPassword_Event_SendResetPasswordLink({required this.email});

  final String email;
}

class ResetPassword_Event_ResendResetPasswordLink extends ResetPassword_Event {
  ResetPassword_Event_ResendResetPasswordLink({required this.email});

  final String email;
}

class ResetPassword_Event_ResetPassword extends ResetPassword_Event {
  ResetPassword_Event_ResetPassword({required this.password});

  final String password;
}
