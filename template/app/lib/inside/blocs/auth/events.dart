import 'dart:async';

sealed class Auth_Event {}

class Auth_Event_SignOut extends Auth_Event {}

class Auth_Event_AccessTokenAdded extends Auth_Event {
  Auth_Event_AccessTokenAdded({required this.accessToken});
  final String accessToken;
}

class Auth_Event_AccessTokenRemoved extends Auth_Event {}

class Auth_Event_GetAccessTokenFromUri extends Auth_Event {
  Auth_Event_GetAccessTokenFromUri({
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
