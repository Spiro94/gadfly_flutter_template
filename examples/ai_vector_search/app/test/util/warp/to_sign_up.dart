import 'package:flow_test/flow_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../fake/auth_change_effect.dart';
import '../util.dart';

Future<void> arrangeBeforeWarpToSignUp(
  FTArrange<MocksContainer> arrange,
) async {
  final fakeAuthChangeEffect = FakeAuthChangeEffect();
  when(() => arrange.mocks.authChangeEffectProvider.getEffect()).thenAnswer(
    (invocation) => fakeAuthChangeEffect,
  );
  arrange.extras['fakeAuthChangeEffect'] = fakeAuthChangeEffect;
}

Future<void> warpToSignUp(
  FTWarp<MocksContainer> warp,
) async {
  await warp.testerAction.pumpAndSettle();

  final signUpFinder = find.text(
    '''New User? Sign Up''',
    findRichText: true,
  );

  final center = warp.testerAction.getCenter(signUpFinder);
  final rect = warp.testerAction.getRect(signUpFinder);
  await warp.userAction.tapAt(Offset(center.dx + rect.width / 4, center.dy));

  await warp.testerAction.pumpAndSettle();
}
