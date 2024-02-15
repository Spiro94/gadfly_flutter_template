// ignore_for_file: depend_on_referenced_packages
import 'dart:async';

import 'package:gotrue/src/types/auth_state.dart';
import 'package:row_level_security/effects/auth_change/effect.dart';
import 'package:supabase/src/supabase_client.dart';

class FakeAuthChangeEffect implements AuthChangeEffect {
  @override
  SupabaseClient get supabaseClient => throw UnimplementedError();

  StreamController<AuthState>? streamController;
  StreamSubscription<AuthState>? _subscription;

  @override
  void listen(void Function(AuthState authState) onChange) {
    streamController = StreamController<AuthState>();
    final stream = streamController?.stream;
    _subscription = stream?.listen(onChange);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    if (!(streamController?.isClosed ?? true)) {
      streamController?.close();
    }
  }
}
