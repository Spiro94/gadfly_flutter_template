import 'dart:async';

import 'package:gadfly_flutter_template/external/effect_providers/auth_change/effect.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockAuthChangeEffect extends Mock implements AuthChangeEffect {
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
