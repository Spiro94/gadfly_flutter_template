import 'package:amplitude_repository/amplitude_repository.dart';
import 'package:collection/collection.dart';
import 'package:flow_test/flow_test.dart';
import 'package:flutter/material.dart';
import 'package:gadfly_flutter_template/effects/auth_change/provider.dart';
import 'package:gadfly_flutter_template/effects/now/provider.dart';
import 'package:gadfly_flutter_template/effects/play_audio/provider.dart';
import 'package:gadfly_flutter_template/effects/record_audio/provider.dart';
import 'package:gadfly_flutter_template/effects/uuid/provider.dart';
import 'package:gadfly_flutter_template/repositories/audio/repository.dart';
import 'package:gadfly_flutter_template/repositories/auth/repository.dart';
import 'package:mocktail/mocktail.dart';

import 'app_builder.dart';
import 'effects/auth_change_effect.dart';
import 'effects/now_effect.dart';
import 'effects/play_audio_effect.dart';
import 'effects/record_audio_effect.dart';
import 'effects/uuid_effect.dart';

List<MockedApp> createdMockedApps({
  required bool hasAccessToken,
  required String? deepLinkOverride,
}) =>
    [
      MockedApp(
        key: const Key('app'),
        events: [],
        mocks: MocksContainer(),
        accessToken: hasAccessToken ? 'fakeAccessToken' : null,
        deepLinkOverride: deepLinkOverride,
      ),
    ];

class MockedApp extends FTMockedApp<MocksContainer> {
  MockedApp({
    required Key key,
    required super.events,
    required super.mocks,
    required String? accessToken,
    required String? deepLinkOverride,
  }) : super(
          appBuilder: () async => await testAppBuilder(
            key: key,
            mocks: mocks,
            accessToken: accessToken,
            deepLinkOverride: deepLinkOverride,
          ),
        );
}

class MocksContainer {
  final authChangeEffectProvider = MockAuthChangeEffectProvider();
  final nowEffectProvider = MockNowEffectProvider();
  final playAudioEffectProvider = MockPlayAudioEffectProvider();
  final recordAudioEffectProvider = MockRecordAudioEffectProvider();
  final uuidEffectProvider = MockUuidEffectProvider();

  void mockEffectProviders() {
    when(authChangeEffectProvider.getEffect)
        .thenAnswer((invocation) => authChangeEffect);

    when(nowEffectProvider.getEffect).thenAnswer((invocation) => nowEffect);

    when(
      () => playAudioEffectProvider.getEffect(
        debugLabel: any(named: 'debugLabel'),
      ),
    ).thenAnswer((invocation) {
      final debugLabel =
          invocation.namedArguments[const Symbol('debugLabel')] as String;

      final effect = playAudioEffects
              .firstWhereOrNull((e) => e.debugLabel == debugLabel) ??
          MockPlayAudioEffect(debugLabel: debugLabel);
      playAudioEffects.add(effect);

      return effect;
    });

    when(recordAudioEffectProvider.getEffect)
        .thenAnswer((invocation) => recordAudioEffect);
    when(uuidEffectProvider.getEffect).thenAnswer((invocation) => uuidEffect);
  }

  final authChangeEffect = MockAuthChangeEffect();
  final nowEffect = MockNowEffect();
  final playAudioEffects = <MockPlayAudioEffect>[];
  final recordAudioEffect = MockRecordAudioEffect();
  final uuidEffect = MockUuidEffect();

  final amplitudeRepository = MockAmplitudeRepository();
  final audioRepository = MockAudioRepository();
  final authRepository = MockAuthRepository();
}

// -- Effect Providers

class MockAuthChangeEffectProvider extends Mock
    implements AuthChangeEffectProvider {}

class MockNowEffectProvider extends Mock implements NowEffectProvider {}

class MockPlayAudioEffectProvider extends Mock
    implements PlayAudioEffectProvider {}

class MockRecordAudioEffectProvider extends Mock
    implements RecordAudioEffectProvider {}

class MockUuidEffectProvider extends Mock implements UuidEffectProvider {}

// -- Effects
// See effects directory

// -- Repositories

class MockAmplitudeRepository extends Mock implements AmplitudeRepository {}

class MockAudioRepository extends Mock implements AudioRepository {}

class MockAuthRepository extends Mock implements AuthRepository {}
