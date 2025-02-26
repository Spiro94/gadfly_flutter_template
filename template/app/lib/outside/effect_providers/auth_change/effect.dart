import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../shared/mixins/logging.dart';

class AuthChangeEffect with SharedMixin_Logging {
  AuthChangeEffect({
    required this.supabaseClient,
  });

  final SupabaseClient supabaseClient;

  StreamSubscription<AuthState>? _subscription;

  void listen(void Function(AuthState authState) onChange) {
    _subscription = supabaseClient.auth.onAuthStateChange.listen(
      (authState) {
        log.fine('authState change: ${authState.event.name}');
        onChange(authState);
      },
      onError: (e) {},
    );
  }

  void dispose() {
    log.finer('dispose');
    _subscription?.cancel();
  }
}
