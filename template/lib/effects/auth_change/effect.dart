// coverage:ignore-file
import 'dart:async';

import 'package:logging/logging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthChangeEffect {
  AuthChangeEffect({
    required this.supabaseClient,
  });

  final SupabaseClient supabaseClient;

  StreamSubscription<AuthState>? _subscription;

  final _log = Logger('auth_change_effect');

  void listen(void Function(AuthState authState) onChange) {
    _subscription = supabaseClient.auth.onAuthStateChange.listen((authState) {
      _log.fine('authState change: ${authState.event.name}');
      onChange(authState);
    });
  }

  void dispose() {
    _log.finer('dispose');
    _subscription?.cancel();
  }
}
