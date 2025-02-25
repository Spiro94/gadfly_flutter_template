import 'package:logging/logging.dart' as logging;

import '../external/client_providers/sentry/configuration.dart';
import '../external/client_providers/supabase/configuration.dart';
import '../external/effect_providers/mixpanel/configuration.dart';
import '../external/theme/theme.dart';
import '../internal/i18n/translations.g.dart';

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
  final ExternalTheme theme;
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
