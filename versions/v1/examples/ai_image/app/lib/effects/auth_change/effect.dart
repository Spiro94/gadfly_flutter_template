// coverage:ignore-file
import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

class AuthChangeEffect {
  AuthChangeEffect({
    required this.supabaseClient,
  });

  final SupabaseClient supabaseClient;

  StreamSubscription<AuthState>? _subscription;

  void listen(void Function(AuthState authState) onChange) {
    _subscription = supabaseClient.auth.onAuthStateChange.listen(onChange);
  }

  void dispose() {
    _subscription?.cancel();
  }
}
