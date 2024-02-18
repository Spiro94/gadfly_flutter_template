// coverage:ignore-file
import 'package:supabase_flutter/supabase_flutter.dart';

import 'effect.dart';

class AuthChangeEffectProvider {
  AuthChangeEffectProvider({
    required this.supabaseClient,
  });

  final SupabaseClient supabaseClient;

  AuthChangeEffect getEffect() {
    return AuthChangeEffect(supabaseClient: supabaseClient);
  }
}
