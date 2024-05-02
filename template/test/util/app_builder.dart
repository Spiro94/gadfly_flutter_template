import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gadfly_flutter_template/main/app_builder.dart';

import 'mocked_app.dart';

FutureOr<Widget> testAppBuilder({
  required Key key,
  required String? accessToken,
  required String? deepLinkOverride,
  required MocksContainer mocks,
}) async {
  mocks.mockEffectProviders();

  return await appBuilder(
    key: key,
    deepLinkOverride: deepLinkOverride,
    accessToken: accessToken,
    amplitudeRepository: mocks.amplitudeRepository,
    authRepository: mocks.authRepository,
    nowEffectProvider: mocks.nowEffectProvider,
    sharedPreferencesEffectProvider: mocks.sharedPreferencesEffectProvider,
    uuidEffectProvider: mocks.uuidEffectProvider,
  );
}
