import 'package:amplitude_repository/amplitude_repository.dart';
import 'package:flow_test/flow_test.dart';
import 'package:flutter/material.dart';
import 'package:mocktail/mocktail.dart';
import 'package:stripe_edge_function/effects/auth_change/provider.dart';
import 'package:stripe_edge_function/effects/now/provider.dart';
import 'package:stripe_edge_function/repositories/auth/repository.dart';
// ATTENTION 1/3
import 'package:stripe_edge_function/repositories/payments/repository.dart';
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

  // ATTENTION 2/3
  final paymentsRepository = MockPaymentsRepository();
  // --
}

class MockAuthChangeEffectProvider extends Mock
    implements AuthChangeEffectProvider {}

class MockNowEffectProvider extends Mock implements NowEffectProvider {}

class MockAmplitudeRepository extends Mock implements AmplitudeRepository {}

class MockAuthRepository extends Mock implements AuthRepository {}

// ATTENTION 3/3
class MockPaymentsRepository extends Mock implements PaymentsRepository {}
// ---
