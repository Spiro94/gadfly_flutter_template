import 'package:logging/logging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CountRepository {
  CountRepository({
    required SupabaseClient supabaseClient,
  }) : _supabaseClient = supabaseClient;

  final SupabaseClient _supabaseClient;

  final _log = Logger('CountRepository');

  String? get _currentUserId => _supabaseClient.auth.currentSession?.user.id;

  Future<int> getCount() async {
    _log.info('getCount');

    final response = await _supabaseClient
        .from('counts')
        .select<PostgrestMap>('count')
        .single();

    _log.info('getCount response: $response');

    return response['count'] as int;
  }

  Future<int> updateCount({
    required int newCount,
  }) async {
    _log.info('updateCount');

    final response = await _supabaseClient
        .from('counts')
        .update(
          {'count': newCount},
        )
        .eq(
          'user_id',
          _currentUserId,
        )
        .select<PostgrestMap>('count')
        .single();

    _log.info('updateCount response: $response');

    return response['count'] as int;
  }
}
