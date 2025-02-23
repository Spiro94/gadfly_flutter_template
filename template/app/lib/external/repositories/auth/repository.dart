import 'package:supabase_flutter/supabase_flutter.dart';

import '../base_class.dart';

class AuthRepository extends Base_Repository {
  AuthRepository({
    required String deepLinkBaseUri,
    required SupabaseClient supabaseClient,
  })  : _deepLinkBaseUri = deepLinkBaseUri,
        _supabaseClient = supabaseClient;

  final String _deepLinkBaseUri;
  final SupabaseClient _supabaseClient;
  String get _signUpRedirectUrl => '''$_deepLinkBaseUri/#/deep/verify-email/''';
  String get _resetPasswordRedirectUrl =>
      '''$_deepLinkBaseUri/#/deep/reset-password/''';

  @override
  Future<void> init() async {}

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    log.info('signIn');
    log.fine('email: $email');

    await _supabaseClient.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    log.info('signOut');

    await _supabaseClient.auth.signOut();
  }

  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    log.info('signUp');
    log.fine('email: $email');
    log.fine('redirectTo: $_signUpRedirectUrl');

    await _supabaseClient.auth.signUp(
      email: email,
      emailRedirectTo: _signUpRedirectUrl,
      password: password,
    );
  }

  Future<void> sendResetPasswordLink({
    required String email,
  }) async {
    log.info('sendResetPasswordLink');
    log.fine('redirectTo: $_resetPasswordRedirectUrl');

    await _supabaseClient.auth.resetPasswordForEmail(
      email,
      redirectTo: _resetPasswordRedirectUrl,
    );
  }

  Future<void> resetPassword({
    required String password,
  }) async {
    log.info('resetPassword');

    await _supabaseClient.auth.updateUser(
      UserAttributes(
        password: password,
      ),
    );
  }

  Future<String> getAccessTokenFromUri({
    required Uri uri,
    required String? code,
    required String? refreshToken,
  }) async {
    log.info('getAccessTokenFromUri');
    if (refreshToken != null && refreshToken.isNotEmpty) {
      log.fine('refreshToken: $refreshToken');
      final response = await _supabaseClient.auth.setSession(refreshToken);
      return response.session!.accessToken;
    }

    if (code != null && code.isNotEmpty) {
      log.fine('code: $code');
      final response = await _supabaseClient.auth.exchangeCodeForSession(code);
      return response.session.accessToken;
    }

    log.fine('uri: $uri');
    final response = await _supabaseClient.auth.getSessionFromUrl(uri);
    return response.session.accessToken;
  }

  Future<void> resendEmailVerificationLink({
    required String email,
  }) async {
    log.info('resendEmailVerificationLink');
    log.fine('redirectTo: $_signUpRedirectUrl');

    final resendResponse = await _supabaseClient.auth.resend(
      email: email,
      type: OtpType.signup,
      emailRedirectTo: _signUpRedirectUrl,
    );

    log.info('message_id: ${resendResponse.messageId}');
  }
}
