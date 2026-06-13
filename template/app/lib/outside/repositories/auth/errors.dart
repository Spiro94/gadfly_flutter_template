import 'package:supabase_flutter/supabase_flutter.dart';

/// The auth failures the rest of the application can react to. Blocs map
/// these to user-facing messages, so raw backend exceptions (and their
/// internals) never reach the UI.
enum Auth_ErrorCode {
  invalidCredentials,
  emailNotConfirmed,
  userAlreadyExists,
  weakPassword,
  rateLimited,

  /// The redirect link after sign up seems to always be in this state, but
  /// it doesn't affect the user, so callers can choose to ignore it.
  flowStateNotFound,
  network,
  unknown,
}

class Auth_Error implements Exception {
  const Auth_Error({required this.code});

  /// Maps a backend [error] to an [Auth_Error] so supabase types stay behind
  /// the repository boundary.
  factory Auth_Error.from(Object error) {
    if (error is Auth_Error) {
      return error;
    }

    if (error is AuthRetryableFetchException) {
      return const Auth_Error(code: Auth_ErrorCode.network);
    }

    if (error is AuthException) {
      return switch (error.code) {
        'invalid_credentials' => const Auth_Error(
          code: Auth_ErrorCode.invalidCredentials,
        ),
        'email_not_confirmed' => const Auth_Error(
          code: Auth_ErrorCode.emailNotConfirmed,
        ),
        'user_already_exists' || 'email_exists' => const Auth_Error(
          code: Auth_ErrorCode.userAlreadyExists,
        ),
        'weak_password' => const Auth_Error(code: Auth_ErrorCode.weakPassword),
        'over_request_rate_limit' || 'over_email_send_rate_limit' =>
          const Auth_Error(code: Auth_ErrorCode.rateLimited),
        'flow_state_not_found' || 'flow_state_expired' => const Auth_Error(
          code: Auth_ErrorCode.flowStateNotFound,
        ),
        _ => const Auth_Error(code: Auth_ErrorCode.unknown),
      };
    }

    return const Auth_Error(code: Auth_ErrorCode.unknown);
  }

  final Auth_ErrorCode code;

  @override
  String toString() => 'Auth_Error(code: ${code.name})';
}
