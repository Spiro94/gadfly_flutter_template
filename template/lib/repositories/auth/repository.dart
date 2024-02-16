import 'package:logging/logging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  AuthRepository({
    required String deepLinkHostname,
    required SupabaseClient supabaseClient,
  })  : _deepLinkHostname = deepLinkHostname,
        _supabaseClient = supabaseClient;

  final String _deepLinkHostname;
  final SupabaseClient _supabaseClient;

  final _log = Logger('auth_repository');

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    _log.info('signIn');

    await _supabaseClient.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    _log.info('signOut');

    await _supabaseClient.auth.signOut();
  }

  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    _log.info('signUp');

    await _supabaseClient.auth.signUp(
      email: email,
      password: password,
    );
  }

  Future<void> forgotPassword({
    required String email,
  }) async {
    _log.info('forgotPassword');

    await _supabaseClient.auth.resetPasswordForEmail(
      email,
      redirectTo: '$_deepLinkHostname/#/deep/resetPassword',
    );
  }

  Future<void> resetPassword({
    required String password,
  }) async {
    _log.info('resetPassword');

    await _supabaseClient.auth.updateUser(
      UserAttributes(
        password: password,
      ),
    );
  }

  Future<String> setSessionFromUri({
    required Uri uri,
  }) async {
    _log.info('setSessionFromUri');

    final session = await _supabaseClient.auth.getSessionFromUrl(uri);

    return session.session.accessToken;
  }
}
