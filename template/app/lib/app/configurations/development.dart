import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart' as logging;

import '../../inside/i18n/translations.g.dart';
import '../../outside/client_providers/supabase/configuration.dart';
import '../../outside/effect_providers/mixpanel/configuration.dart';
import '../../outside/theme/theme.dart';
import '../runner.dart';
import 'configuration.dart';

void main() {
  const siteHost = String.fromEnvironment('SITE_HOST');

  final configuration = AppConfiguration(
    appLocale: AppLocale.en,
    logLevel: logging.Level.ALL,
    theme: OutsideThemes.lightTheme,
    deepLinkBaseUri: kIsWeb
        ? 'http://$siteHost:3000'
        : 'com.gadfly361.gadflyfluttertemplate.deep://deeplink-callback',
    clientProvidersConfigurations: ClientProvidersConfigurations(
      sentry: null,
      supabase: const SupabaseClientProviderConfiguration(
        url: 'http://$siteHost:54321',
        anonKey:
            '''eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0''',
      ),
    ),
    effectProvidersConfigurations: EffectProvidersConfigurations(
      mixpanel: const MixpanelEffectProviderConfiguration(
        sendEvents: false,
        token: null,
        environment: null,
      ),
    ),
  );

  appRunner(configuration: configuration);
}
