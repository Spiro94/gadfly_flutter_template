import 'package:logging/logging.dart';

class AuthRepository {
  final _log = Logger('auth_repository');

  Future<String> fakeSignIn({
    required bool shouldFail,
  }) async {
    _log.info('signIn attempted');

    if (shouldFail) {
      throw Exception('BOOM');
    }

    _log.info('signIn complete');

    return 'fakeAuthToken';
  }
}
