import 'package:amplitude_repository/amplitude_repository.dart';
import 'package:flow_test/flow_test.dart';
import 'package:flutter/material.dart';
import 'package:gadfly_flutter_template/effects/now/provider.dart';
import 'package:gadfly_flutter_template/effects/shared_preferences/provider.dart';
import 'package:gadfly_flutter_template/repositories/auth/repository.dart';

import 'package:mocktail/mocktail.dart';

import 'util.dart';

List<MockedApp> createdMockedApps() => [
      MockedApp(
        key: const Key('app'),
        events: [],
        mocks: MocksContainer(),
      )
    ];

class MockedApp extends FTMockedApp<MocksContainer> {
  MockedApp({
    required Key key,
    required super.events,
    required super.mocks,
  }) : super(
          appBuilder: () async => await testAppBuilder(
            key: key,
            mocks: mocks,
          ),
        );
}

class MocksContainer {
  final nowEffectProvider = MockNowEffectProvider();

  // intentionally not mocked
  final sharedPreferencesEffectProvider =
      SharedPreferencesEffectProvider(prefix: 'app_');

  final authRepository = MockAuthRepository();

  final amplitudeRepository = MockAmplitudeRepository();
}

class MockNowEffectProvider extends Mock implements NowEffectProvider {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockAmplitudeRepository extends Mock implements AmplitudeRepository {}
