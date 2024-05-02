// coverage:ignore-file

import 'package:logging/logging.dart';

class AuthRepository {
  final _log = Logger('auth_repository');

  Future<String> signIn({
    required String email,
    required String password,
  }) async {
    _log.info('signIn');
    // TODO: replace with real sign in

    const accessToken = 'FAKE_ACCESS_TOKEN';

    return accessToken;
  }

  Future<void> signOut() async {
    _log.info('signOut');
    // TODO: replace with real sign out
  }
}
