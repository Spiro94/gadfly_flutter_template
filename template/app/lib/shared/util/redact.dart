/// Helpers for keeping secrets and PII out of logs.
///
/// Log records are forwarded to Sentry via `LoggingIntegration`, so anything
/// logged can leave the device. Always pass tokens, emails, and incoming URIs
/// through these helpers before logging them.
class SharedUtil_Redact {
  static const _redacted = '<redacted>';

  /// Query/fragment parameter keys whose values must never be logged.
  static const sensitiveParamKeys = {
    'access_token',
    'refresh_token',
    'code',
    'token',
    'token_hash',
  };

  static final _jwtPattern = RegExp(
    r'eyJ[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+',
  );

  static final _sensitiveParamPattern = RegExp(
    '(${sensitiveParamKeys.join('|')})=([^&\\s]+)',
  );

  /// Scrubs token-like values (JWTs, `access_token=...` style parameters)
  /// from arbitrary [text]. Used as a safety net before data leaves the
  /// device, e.g. in Sentry's beforeSend hooks.
  static String scrub(String text) {
    return text
        .replaceAll(_jwtPattern, _redacted)
        .replaceAllMapped(
          _sensitiveParamPattern,
          (match) => '${match[1]}=$_redacted',
        );
  }

  /// Keeps a short prefix of [token] so related log lines can be correlated
  /// without exposing the secret itself.
  static String redactToken(String? token) {
    if (token == null || token.isEmpty) {
      return _redacted;
    }

    if (token.length <= 6) {
      return _redacted;
    }

    return '${token.substring(0, 6)}…$_redacted';
  }

  /// Masks the local part of an [email], e.g. `jane@example.com` becomes
  /// `j***@example.com`.
  static String maskEmail(String? email) {
    if (email == null || email.isEmpty) {
      return _redacted;
    }

    final atIndex = email.indexOf('@');
    if (atIndex <= 0) {
      return _redacted;
    }

    return '${email[0]}***${email.substring(atIndex)}';
  }

  /// Returns [uri] as a string with all query and fragment parameter values
  /// stripped (keys are kept), so auth callback URIs can be logged safely.
  static String sanitizeUri(Uri uri) {
    final sanitized = uri.replace(
      queryParameters:
          uri.hasQuery
              ? uri.queryParameters.map((key, _) => MapEntry(key, _redacted))
              : null,
      fragment: uri.hasFragment ? sanitizeFragment(uri.fragment) : null,
    );

    return Uri.decodeFull(sanitized.toString());
  }

  /// Redacts the values of any `key=value` pairs found in a deep link
  /// [fragment], which is where supabase auth places tokens on web.
  static String sanitizeFragment(String fragment) {
    if (!fragment.contains('=')) {
      return fragment;
    }

    return fragment.replaceAllMapped(
      RegExp('([^&?=/]+)=([^&]*)'),
      (match) => '${match[1]}=$_redacted',
    );
  }
}
