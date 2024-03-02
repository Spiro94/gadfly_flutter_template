// coverage:ignore-file
import 'package:supabase_flutter/supabase_flutter.dart';

import 'effect.dart';

class AuthChangeEffectProvider {
  AuthChangeEffectProvider({
    required SupabaseClient supabaseClient,
  }) : _supabaseClient = supabaseClient;

  final SupabaseClient _supabaseClient;

  AuthChangeEffect getEffect() {
    return AuthChangeEffect(supabaseClient: _supabaseClient);
  }
}
