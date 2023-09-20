import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gadfly_flutter_template/app/builder.dart';

import 'mocked_app.dart';

FutureOr<Widget> testAppBuilder({
  required Key key,
  required String? accessToken,
  required String? deepLinkOverride,
  required MocksContainer mocks,
}) async {
  return await appBuilder(
    key: key,
    deepLinkOverride: deepLinkOverride,
    accessToken: accessToken,
    amplitudeRepository: mocks.amplitudeRepository,
    authChangeEffectProvider: mocks.authChangeEffectProvider,
    nowEffectProvider: mocks.nowEffectProvider,
    authRepository: mocks.authRepository,
  );
}
