import 'package:flutter_bloc/flutter_bloc.dart';

import 'base_class.dart';
import 'supabase/client_provider.dart';

/// When adding a new client provider, be sure to add it to:
/// - [_list]
/// - [createProviders]
///   - Make sure to add the concrete type to `RepositoryProvider<ConcreteType>`
///     otherwise it will register the base class.
class AllClientProviders {
  AllClientProviders({
    required this.supabaseClientProvider,
  });

  final SupabaseClientProvider supabaseClientProvider;

  List<Base_ClientProvider> get _list => [
        supabaseClientProvider,
      ];

  List<RepositoryProvider<Base_ClientProvider>> createProviders() {
    return [
      RepositoryProvider<SupabaseClientProvider>.value(
        value: supabaseClientProvider,
      ),
    ];
  }

  Future<void> initialize() async {
    await Future.forEach(_list, (r) async {
      r.log.fine('init');
      await r.init();
    });
  }
}
