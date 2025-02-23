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

class AuthEvent_GetAccessTokenFromUri extends AuthEvent {
  AuthEvent_GetAccessTokenFromUri({
    required this.errorMessageCompleter,
    required this.code,
    required this.refreshToken,
    required this.uri,
  });

  final Completer<String?> errorMessageCompleter;
  final String? code;
  final String? refreshToken;
  final Uri uri;
}
