import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/builder.dart';
import '../util/abstracts/base_provider.dart';
import '../util/abstracts/base_providers.dart';
import 'sentry/client_provider.dart';
import 'supabase/client_provider.dart';

/// When adding a new client provider, be sure to add it to:
/// - [getList]
class AllClientProviders extends OutsideUtilAbstract_BaseProviders {
  AllClientProviders({
    required this.sentryClientProvider,
    required this.supabaseClientProvider,
  });

  final SentryClientProvider sentryClientProvider;
  final SupabaseClientProvider supabaseClientProvider;

  @override
  List<OutsideUtilAbstract_BaseProvider> getList() => [
        sentryClientProvider,
        supabaseClientProvider,
      ];

  /// Client Providers are not passed into [appBuilder], and therefore this
  /// list can be empty.
  @override
  List<RepositoryProvider<OutsideUtilAbstract_BaseProvider>>
      createProviders() => [
            // Do not add anything here. This is intentionally empty.
          ];
}
