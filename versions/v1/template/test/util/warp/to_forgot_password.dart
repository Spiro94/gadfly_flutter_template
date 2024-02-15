import 'package:flow_test/flow_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../fake/auth_change_effect.dart';
import '../util.dart';

Future<void> arrangeBeforeWarpToForgotPassword(
  FTArrange<MocksContainer> arrange,
) async {
  final fakeAuthChangeEffect = FakeAuthChangeEffect();
  when(() => arrange.mocks.authChangeEffectProvider.getEffect()).thenAnswer(
    (invocation) => fakeAuthChangeEffect,
  );
  arrange.extras['fakeAuthChangeEffect'] = fakeAuthChangeEffect;
}

Future<void> warpToForgotPassword(
  FTWarp<MocksContainer> warp,
) async {
  await warp.testerAction.pumpAndSettle();

  final forgotPasswordFinder = find.text(
    '''Forgot Password''',
  );

  await warp.userAction.tap(forgotPasswordFinder);

  await warp.testerAction.pumpAndSettle();
}
