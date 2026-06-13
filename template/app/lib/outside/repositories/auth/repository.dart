import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../shared/models/auth_user.dart';
import '../../../shared/util/redact.dart';
import '../../client_providers/sentry/client_provider.dart';
import '../../effect_providers/mixpanel/effect_provider.dart';
import '../base.dart';
import 'errors.dart';

class Auth_Repository extends Repository_Base {
  Auth_Repository({
    required String deepLinkBaseUri,
    required Mixpanel_EffectProvider mixpanelEffectProvider,
    required Sentry_ClientProvider sentryClientProvider,
    required SupabaseClient supabaseClient,
  }) : _deepLinkBaseUri = deepLinkBaseUri,
       _mixpanelEffectProvider = mixpanelEffectProvider,
       _sentryClientProvider = sentryClientProvider,
       _supabaseClient = supabaseClient;

  final String _deepLinkBaseUri;
  final Mixpanel_EffectProvider _mixpanelEffectProvider;
  final Sentry_ClientProvider _sentryClientProvider;
  final SupabaseClient _supabaseClient;
  String get _signUpRedirectUrl => '''$_deepLinkBaseUri/#/deep/verify-email/''';
  String get _resetPasswordRedirectUrl =>
      '''$_deepLinkBaseUri/#/deep/reset-password/''';

  @override
  Future<void> init() async {}

  /// Maps backend exceptions to [Auth_Error] so supabase types never cross
  /// the repository boundary.
  Future<T> _guard<T>(Future<T> Function() fn) async {
    try {
      return await fn();
    } catch (e, stackTrace) {
      Error.throwWithStackTrace(Auth_Error.from(e), stackTrace);
    }
  }

  Future<void> updatesUsersInClients() async {
    final user = getCurrentUser();
    final email = user?.email;
    final id = user?.id;

    await _sentryClientProvider.setUserId(userId: id);
    _mixpanelEffectProvider.getEffect().setUser(sub: id, email: email);
  }

  SharedModel_AuthUser? getCurrentUser() {
    final user = _supabaseClient.auth.currentUser;
    if (user == null) {
      return null;
    }

    return SharedModel_AuthUser(id: user.id, email: user.email);
  }

  Future<void> signIn({required String email, required String password}) async {
    log.info('signIn');
    log.fine('email: ${SharedUtil_Redact.maskEmail(email)}');

    await _guard(
      () => _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      ),
    );
  }

  Future<void> signOut() async {
    log.info('signOut');

    await _guard(() => _supabaseClient.auth.signOut());
  }

  Future<void> signUp({required String email, required String password}) async {
    log.info('signUp');
    log.fine('email: ${SharedUtil_Redact.maskEmail(email)}');
    log.fine('redirectTo: $_signUpRedirectUrl');

    await _guard(
      () => _supabaseClient.auth.signUp(
        email: email,
        emailRedirectTo: _signUpRedirectUrl,
        password: password,
      ),
    );
  }

  Future<void> sendResetPasswordLink({required String email}) async {
    log.info('sendResetPasswordLink');
    log.fine('redirectTo: $_resetPasswordRedirectUrl');

    await _guard(
      () => _supabaseClient.auth.resetPasswordForEmail(
        email,
        redirectTo: _resetPasswordRedirectUrl,
      ),
    );
  }

  Future<void> resetPassword({required String password}) async {
    log.info('resetPassword');

    await _guard(
      () => _supabaseClient.auth.updateUser(UserAttributes(password: password)),
    );
  }

  Future<String> getAccessTokenFromUri({
    required Uri uri,
    required String? code,
    required String? refreshToken,
  }) async {
    log.info('getAccessTokenFromUri');
    return _guard(() async {
      if (refreshToken != null && refreshToken.isNotEmpty) {
        log.fine(
          'refreshToken: ${SharedUtil_Redact.redactToken(refreshToken)}',
        );
        final response = await _supabaseClient.auth.setSession(refreshToken);
        return response.session!.accessToken;
      }

      if (code != null && code.isNotEmpty) {
        log.fine('code: ${SharedUtil_Redact.redactToken(code)}');
        final response = await _supabaseClient.auth.exchangeCodeForSession(
          code,
        );
        return response.session.accessToken;
      }

      log.fine('uri: ${SharedUtil_Redact.sanitizeUri(uri)}');
      final response = await _supabaseClient.auth.getSessionFromUrl(uri);
      return response.session.accessToken;
    });
  }

  Future<void> resendEmailVerificationLink({required String email}) async {
    log.info('resendEmailVerificationLink');
    log.fine('redirectTo: $_signUpRedirectUrl');

    final resendResponse = await _guard(
      () => _supabaseClient.auth.resend(
        email: email,
        type: OtpType.signup,
        emailRedirectTo: _signUpRedirectUrl,
      ),
    );

    log.info('message_id: ${resendResponse.messageId}');
  }
}
