import 'package:logging/logging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SearchRepository {
  SearchRepository({
    required SupabaseClient supabaseClient,
  }) : _supabaseClient = supabaseClient;

  final SupabaseClient _supabaseClient;

  final _log = Logger('search_repository');

  Future<String> vectorSearch({required String query}) async {
    _log.info('vectorSearch');

    // Ask a question
    final response = await _supabaseClient.functions.invoke(
      'vector_search',
      body: {
        'query': query,
      },
    );

    // Return the answer, which is a string in Markdown format
    return (response.data as Map<String, dynamic>)['text'] as String;
  }
}
