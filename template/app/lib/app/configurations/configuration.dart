import 'package:logging/logging.dart' as logging;

import '../../inside/i18n/translations.g.dart';
import '../../outside/client_providers/sentry/client_provider_configuration.dart';
import '../../outside/client_providers/supabase/client_provider_configuration.dart';
import '../../outside/effect_providers/mixpanel/effect_provider_configuration.dart';
import '../../outside/theme/theme.dart';

class AppConfiguration {
  const AppConfiguration({
    required this.appLocale,
    required this.logLevel,
    required this.theme,
    required this.deepLinkBaseUri,
    required this.clientProvidersConfigurations,
    required this.effectProvidersConfigurations,
  });

  final AppLocale appLocale;
  final logging.Level logLevel;
  final OutsideTheme theme;
  final String deepLinkBaseUri;

  final ClientProvidersConfigurations clientProvidersConfigurations;
  final EffectProvidersConfigurations effectProvidersConfigurations;

  /// Fails fast on startup if any configured value still contains the
  /// `CHANGE_ME` placeholder, so a build can't ship with template
  /// credentials.
  void validate() {
    final sentry = clientProvidersConfigurations.sentry;
    final supabase = clientProvidersConfigurations.supabase;
    final mixpanel = effectProvidersConfigurations.mixpanel;

    final values = {
      'deepLinkBaseUri': deepLinkBaseUri,
      'sentry.dsn': sentry?.dsn,
      'supabase.url': supabase.url,
      'supabase.anonKey': supabase.anonKey,
      'mixpanel.token': mixpanel.token,
      'mixpanel.environment': mixpanel.environment,
    };

    final placeholders =
        values.entries
            .where((entry) => entry.value?.contains('CHANGE_ME') ?? false)
            .map((entry) => entry.key)
            .toList();

    if (placeholders.isNotEmpty) {
      throw StateError(
        'AppConfiguration still contains CHANGE_ME placeholders: '
        '${placeholders.join(', ')}. '
        'Update lib/app/configurations/ before running this build.',
      );
    }
  }
}

class ClientProvidersConfigurations {
  ClientProvidersConfigurations({required this.sentry, required this.supabase});

  final Sentry_ClientProvider_Configuration? sentry;
  final Supabase_ClientProvider_Configuration supabase;
}

class EffectProvidersConfigurations {
  EffectProvidersConfigurations({required this.mixpanel});

  final Mixpanel_EffectProvider_Configuration mixpanel;
}
