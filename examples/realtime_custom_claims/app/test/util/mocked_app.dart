// ATTENTION 1/4
import 'dart:async';
// ---
import 'package:amplitude_repository/amplitude_repository.dart';
import 'package:flow_test/flow_test.dart';
import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:realtime_custom_claims/effects/auth_change/provider.dart';
import 'package:realtime_custom_claims/effects/now/provider.dart';
import 'package:realtime_custom_claims/repositories/auth/repository.dart';
// ATTENTION 2/4
import 'package:realtime_custom_claims/repositories/custom_claims/repository.dart';
// ---

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
  final authChangeEffectProvider = MockAuthChangeEffectProvider();
  final nowEffectProvider = MockNowEffectProvider();

  final amplitudeRepository = MockAmplitudeRepository();
  final authRepository = MockAuthRepository();
  // ATTENTION 3/4
  final customClaimsRepository = MockCustomClaimsRepository();
  // ---
}

class MockAuthChangeEffectProvider extends Mock
    implements AuthChangeEffectProvider {}

class MockNowEffectProvider extends Mock implements NowEffectProvider {}

class MockAmplitudeRepository extends Mock implements AmplitudeRepository {}

class MockAuthRepository extends Mock implements AuthRepository {}

// ATTENTION 4/4
class MockCustomClaimsRepository extends Mock
    implements CustomClaimsRepository {
  final customClaimUpdatesStreamController =
      StreamController<List<Map<String, dynamic>>>();
}
// ---
