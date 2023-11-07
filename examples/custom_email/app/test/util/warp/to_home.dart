import 'package:flow_test/flow_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../fake/auth_change_effect.dart';
import '../util.dart';

Future<void> arrangeBeforeWarpToHome(
  FTArrange<MocksContainer> arrange,
) async {
  final fakeAuthChangeEffect = FakeAuthChangeEffect();
  when(() => arrange.mocks.authChangeEffectProvider.getEffect()).thenAnswer(
    (invocation) => fakeAuthChangeEffect,
  );
  arrange.extras['fakeAuthChangeEffect'] = fakeAuthChangeEffect;
}

// Note: Set `hasAccessToken` to true
