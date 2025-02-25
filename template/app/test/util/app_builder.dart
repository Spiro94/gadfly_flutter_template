import 'dart:async';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:gadfly_flutter_template/app/builder.dart';
import 'package:gadfly_flutter_template/internal/i18n/translations.g.dart';

import 'mocks/mocked_app.dart';

FutureOr<Widget> testAppBuilder({
  required Key key,
  required String? accessToken,
  required String? deepLinkOverride,
  required MocksContainer mocks,
  required ThemeData materialThemeData,
  required FThemeData foruiThemeData,
}) async {
  mocks.mockEffectProviderGetEffectMethods();

  return await appBuilder(
    key: key,
    deepLinkFragmentOverride: deepLinkOverride,
    appLocale: AppLocale.en,
    materialThemeData: materialThemeData,
    foruiThemeData: foruiThemeData,
    accessToken: accessToken,
    effectProviders: mocks.effectProviders,
    repositories: mocks.repositories,
  );
}
