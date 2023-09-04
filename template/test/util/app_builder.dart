import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gadfly_flutter_template/app/builder.dart';
import 'package:gadfly_flutter_template/app/theme.dart';

import 'util.dart';

FutureOr<Widget> testAppBuilder({
  required Key key,
  required String? accessToken,
  required MocksContainer mocks,
}) async {
  return await appBuilder(
    themeMode: ThemeMode.light,
    themeDataLight: appThemeDataLight,
    themeDataDark: appThemeDataDark,
    nowEffectProvider: mocks.nowEffectProvider,
    sharedPreferencesEffectProvider: mocks.sharedPreferencesEffectProvider,
    authRepository: mocks.authRepository,
    amplitudeRepository: mocks.amplitudeRepository,
  );
}
