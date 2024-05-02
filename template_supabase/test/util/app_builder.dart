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
  mocks.mockEffectProviders();

  return await appBuilder(
    key: key,
    deepLinkOverride: deepLinkOverride,
    deepLinkStream: const Stream<Uri>.empty(),
    accessToken: accessToken,
    amplitudeRepository: mocks.amplitudeRepository,
    audioRepository: mocks.audioRepository,
    authRepository: mocks.authRepository,
    authChangeEffectProvider: mocks.authChangeEffectProvider,
    nowEffectProvider: mocks.nowEffectProvider,
    playAudioEffectProvider: mocks.playAudioEffectProvider,
    recordAudioEffectProvider: mocks.recordAudioEffectProvider,
    uuidEffectProvider: mocks.uuidEffectProvider,
  );
}
