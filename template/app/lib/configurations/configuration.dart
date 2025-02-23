// coverage:ignore-file

import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:logging/logging.dart' as logging;

import '../external/client_providers/supabase/configuration.dart';
import '../external/effect_providers/mixpanel/configuration.dart';
import '../internal/i18n/translations.g.dart';

class AppConfiguration {
  const AppConfiguration({
    required this.appLocale,
    required this.logLevel,
    required this.materialThemeData,
    required this.foruiThemeData,
    required this.deepLinkBaseUri,
    required this.clientProvidersConfigurations,
    required this.effectProvidersConfigurations,
  });

  final AppLocale appLocale;
  final logging.Level logLevel;
  final ThemeData materialThemeData;
  final FThemeData foruiThemeData;
  final String deepLinkBaseUri;

  final ClientProvidersConfigurations clientProvidersConfigurations;
  final EffectProvidersConfigurations effectProvidersConfigurations;
}

class ClientProvidersConfigurations {
  ClientProvidersConfigurations({
    required this.supabase,
  });

  final SupabaseClientProviderConfiguration supabase;
}

class EffectProvidersConfigurations {
  EffectProvidersConfigurations({
    required this.mixpanel,
  });

  final MixpanelEffectProviderConfiguration mixpanel;
}
