import 'package:logging/logging.dart' as logging;

import '../../inside/i18n/translations.g.dart';
import '../../outside/client_providers/sentry/configuration.dart';
import '../../outside/client_providers/supabase/configuration.dart';
import '../../outside/effect_providers/mixpanel/configuration.dart';
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
}

class ClientProvidersConfigurations {
  ClientProvidersConfigurations({
    required this.sentry,
    required this.supabase,
  });

  final SentryClientProviderConfiguration? sentry;
  final SupabaseClientProviderConfiguration supabase;
}

class EffectProvidersConfigurations {
  EffectProvidersConfigurations({
    required this.mixpanel,
  });

  final MixpanelEffectProviderConfiguration mixpanel;
}
