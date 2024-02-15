import 'package:logging/logging.dart';
// ignore: depend_on_referenced_packages,implementation_imports
import 'package:supabase/src/supabase_stream_builder.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatRepository {
  ChatRepository({
    required SupabaseClient supabaseClient,
  }) : _supabaseClient = supabaseClient;

  final SupabaseClient _supabaseClient;

  final _log = Logger('chat_repository');

  Future<Stream<SupabaseStreamEvent>> getMessagesStream() async {
    _log.info('subscribeToMessages');

    final stream = _supabaseClient.from('messages').stream(primaryKey: ['id']);

    return stream;
  }

  Future<void> sendMessage({
    required String message,
  }) async {
    _log.info('sendMessage');

    await _supabaseClient.from('messages').insert({
      'message': message,
      'user_id': _supabaseClient.auth.currentUser!.id,
    });
  }
}
