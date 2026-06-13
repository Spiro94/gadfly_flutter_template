import '../../outside/repositories/auth/errors.dart';
import '../i18n/translations.g.dart';

/// Maps an [Auth_Error] to a user-facing, localized message. Lives on the
/// inside so the outside layer stays free of i18n concerns.
extension InsideUtil_AuthErrorMessage on Auth_Error {
  String get localizedMessage {
    switch (code) {
      case Auth_ErrorCode.invalidCredentials:
        return t.authError.invalidCredentials;
      case Auth_ErrorCode.emailNotConfirmed:
        return t.authError.emailNotConfirmed;
      case Auth_ErrorCode.userAlreadyExists:
        return t.authError.userAlreadyExists;
      case Auth_ErrorCode.weakPassword:
        return t.authError.weakPassword;
      case Auth_ErrorCode.rateLimited:
        return t.authError.rateLimited;
      case Auth_ErrorCode.flowStateNotFound:
      case Auth_ErrorCode.network:
        return t.authError.network;
      case Auth_ErrorCode.unknown:
        return t.authError.unknown;
    }
  }
}

/// Fallback for unexpected (non-[Auth_Error]) exceptions: never surface raw
/// exception strings to the UI.
String authErrorMessageFrom(Object error) {
  if (error is Auth_Error) {
    return error.localizedMessage;
  }

  return t.authError.unknown;
}
