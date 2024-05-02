import 'package:amplitude_repository/amplitude_repository.dart';
import 'package:flow_test/flow_test.dart';
import 'package:flutter/material.dart';
import 'package:gadfly_flutter_template/effects/now/effect.dart';
import 'package:gadfly_flutter_template/effects/now/provider.dart';
import 'package:gadfly_flutter_template/effects/shared_preferences/effect.dart';
import 'package:gadfly_flutter_template/effects/shared_preferences/provider.dart';
import 'package:gadfly_flutter_template/effects/uuid/effect.dart';
import 'package:gadfly_flutter_template/effects/uuid/provider.dart';
import 'package:gadfly_flutter_template/repositories/auth/repository.dart';
import 'package:mocktail/mocktail.dart';

import 'app_builder.dart';

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
  final nowEffectProvider = MockNowEffectProvider();
  final sharedPreferencesEffectProvider = MockSharedPreferencesEffectProvider();
  final uuidEffectProvider = MockUuidEffectProvider();

  final nowEffect = MockNowEffect();
  final sharedPreferencesEffect = MockSharedPreferencesEffect();
  final uuidEffect = MockUuidEffect();

  void mockEffectProviders() {
    when(nowEffectProvider.getEffect).thenAnswer((invocation) => nowEffect);
    when(sharedPreferencesEffectProvider.getEffect)
        .thenAnswer((invocation) => sharedPreferencesEffect);
    when(uuidEffectProvider.getEffect).thenAnswer((invocation) => uuidEffect);
  }

  final amplitudeRepository = MockAmplitudeRepository();
  final authRepository = MockAuthRepository();
}

// -- Effect Providers

class MockNowEffectProvider extends Mock implements NowEffectProvider {}

class MockSharedPreferencesEffectProvider extends Mock
    implements SharedPreferencesEffectProvider {}

class MockUuidEffectProvider extends Mock implements UuidEffectProvider {}

// -- Effects

class MockNowEffect extends Mock implements NowEffect {}

class MockSharedPreferencesEffect extends Mock
    implements SharedPreferencesEffect {}

class MockUuidEffect extends Mock implements UuidEffect {}

// -- Repositories

class MockAmplitudeRepository extends Mock implements AmplitudeRepository {}

class MockAuthRepository extends Mock implements AuthRepository {}
