import 'dart:async';

import 'package:ai_image/app/builder.dart';
import 'package:flutter/material.dart';

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
    deepLinkStream: const Stream.empty(),
    accessToken: accessToken,
    amplitudeRepository: mocks.amplitudeRepository,
    authChangeEffectProvider: mocks.authChangeEffectProvider,
    nowEffectProvider: mocks.nowEffectProvider,
    authRepository: mocks.authRepository,
    // ATTENTION 1/1
    imageGenerationRepository: mocks.imageGenerationRepository,
    // ---
  );
}
