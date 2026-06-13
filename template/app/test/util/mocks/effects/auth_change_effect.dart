import 'dart:async';

import 'package:gadfly_flutter_template/outside/effect_providers/auth_change/effect.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockAuthChangeEffect extends Mock implements AuthChange_Effect {
  @override
  SupabaseClient get supabaseClient => throw UnimplementedError();

  StreamController<AuthChange_Event>? streamController;
  StreamSubscription<AuthChange_Event>? _subscription;

  @override
  void listen(void Function(AuthChange_Event change) onChange) {
    streamController = StreamController<AuthChange_Event>();
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
