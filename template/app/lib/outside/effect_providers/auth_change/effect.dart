import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../shared/mixins/logging.dart';

/// What the application cares about when the auth session changes. Keeps
/// supabase's `AuthState`/`AuthChangeEvent` types behind this effect.
enum AuthChange_Status {
  signedIn,
  signedOut,

  /// Auth changes the application doesn't react to (token refresh, user
  /// updated, etc.).
  other,
}

class AuthChange_Event {
  const AuthChange_Event({
    required this.status,
    required this.accessToken,
    required this.name,
  });

  final AuthChange_Status status;
  final String? accessToken;

  /// The name of the underlying auth event, for logging.
  final String name;
}

class AuthChange_Effect with SharedMixin_Logging {
  AuthChange_Effect({required this.supabaseClient});

  final SupabaseClient supabaseClient;

  StreamSubscription<AuthState>? _subscription;

  void listen(void Function(AuthChange_Event change) onChange) {
    _subscription = supabaseClient.auth.onAuthStateChange.listen((authState) {
      log.fine('authState change: ${authState.event.name}');
      onChange(_toAuthChangeEvent(authState));
    }, onError: (e) {});
  }

  AuthChange_Event _toAuthChangeEvent(AuthState authState) {
    final status = switch (authState.event) {
      AuthChangeEvent.signedIn => AuthChange_Status.signedIn,
      // Even though deprecated, needed to exhaustively satisfy switch
      // statement
      // ignore: deprecated_member_use
      AuthChangeEvent.userDeleted ||
      AuthChangeEvent.signedOut => AuthChange_Status.signedOut,
      AuthChangeEvent.initialSession ||
      AuthChangeEvent.passwordRecovery ||
      AuthChangeEvent.tokenRefreshed ||
      AuthChangeEvent.userUpdated ||
      AuthChangeEvent.mfaChallengeVerified => AuthChange_Status.other,
    };

    return AuthChange_Event(
      status: status,
      accessToken: authState.session?.accessToken,
      name: authState.event.name,
    );
  }

  void dispose() {
    log.finer('dispose');
    _subscription?.cancel();
  }
}
