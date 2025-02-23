// coverage:ignore-file

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart' as logging;
import '../app/runner.dart';
import '../external/client_providers/supabase/configuration.dart';
import '../external/effect_providers/mixpanel/configuration.dart';
import '../internal/i18n/translations.g.dart';
import '../internal/theme/theme.dart';
import 'configuration.dart';

// TODO: update CHANGE_ME lines

void main() {
  final configuration = AppConfiguration(
    appLocale: AppLocale.en,
    logLevel: logging.Level.INFO,
    materialThemeData: materialThemeData_light,
    foruiThemeData: foruiThemeData_light,
    deepLinkBaseUri: kIsWeb
        ? 'CHANGE_ME'
        : 'com.gadfly361.gadflyfluttertemplate.deep://deeplink-callback',
    clientProvidersConfigurations: ClientProvidersConfigurations(
      supabase: const SupabaseClientProviderConfiguration(
        url: 'CHANGE_ME',
        anonKey: '''CHANGE_ME''',
      ),
    ),
    effectProvidersConfigurations: EffectProvidersConfigurations(
      mixpanel: const MixpanelEffectProviderConfiguration(
        sendEvents: true,
        token: 'CHANGE_ME',
        environment: 'CHANGE_ME',
      ),
    ),
  );

  appRunner(configuration: configuration);
}
