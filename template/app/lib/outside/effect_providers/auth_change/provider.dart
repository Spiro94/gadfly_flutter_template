import 'package:supabase_flutter/supabase_flutter.dart';

import '../base_class.dart';
import 'effect.dart';

class AuthChangeEffectProvider extends Base_EffectProvider<AuthChangeEffect> {
  AuthChangeEffectProvider({
    required SupabaseClient supabaseClient,
  }) : _supabaseClient = supabaseClient;

  final SupabaseClient _supabaseClient;

  @override
  AuthChangeEffect getEffect() {
    return AuthChangeEffect(supabaseClient: _supabaseClient);
  }

  @override
  Future<void> init() async {}
}
