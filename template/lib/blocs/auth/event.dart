import 'dart:async';

sealed class AuthEvent {}

class AuthEvent_SignOut extends AuthEvent {}

class AuthEvent_AccessTokenAdded extends AuthEvent {
  AuthEvent_AccessTokenAdded({
    required this.accessToken,
  });
  final String accessToken;
}

class AuthEvent_AccessTokenRemoved extends AuthEvent {}

class AuthEvent_SetSessionFromDeepLink extends AuthEvent {
  AuthEvent_SetSessionFromDeepLink({
    required this.completer,
    required this.uri,
  });

  final Completer<void> completer;
  final Uri uri;
}
