import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gadfly_flutter_template/app/builder.dart';
import 'package:gadfly_flutter_template/external/theme/theme.dart';
import 'package:gadfly_flutter_template/internal/i18n/translations.g.dart';

import 'mocks/mocked_app.dart';

FutureOr<Widget> testAppBuilder({
  required Key key,
  required String? accessToken,
  required String? deepLinkOverride,
  required MocksContainer mocks,
  required ExternalTheme theme,
}) async {
  mocks.mockEffectProviderGetEffectMethods();

  return await appBuilder(
    key: key,
    deepLinkFragmentOverride: deepLinkOverride,
    appLocale: AppLocale.en,
    theme: theme,
    accessToken: accessToken,
    effectProviders: mocks.effectProviders,
    repositories: mocks.repositories,
  );
}
