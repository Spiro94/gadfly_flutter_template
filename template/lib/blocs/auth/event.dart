sealed class AuthEvent {}

class AuthEvent_AccessTokenAdded extends AuthEvent {
  AuthEvent_AccessTokenAdded({
    required this.accessToken,
  });
  final String accessToken;
}

class AuthEvent_SignOut extends AuthEvent {}
