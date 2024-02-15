import 'package:flow_test/flow_test.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
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

  // find and tap RichText
  // reference: https://stackoverflow.com/questions/60247342/finding-a-textspan-to-tap-on-with-flutter-tests
  final finder = find.byWidgetPredicate((widget) {
    if (widget is RichText) {
      if (widget.text.toPlainText() == '''New User? Sign Up''') {
        widget.text.visitChildren((span) {
          if (span is TextSpan) {
            final recognizer = span.recognizer;
            if (recognizer is TapGestureRecognizer) {
              recognizer.onTap?.call();
              return false;
            }
          }
          return true;
        });
      }
    }
    return false;
  });
  // Note: we are only calling `any` to force the finder to materialize and
  // cause its `onTap` side-effect.
  warp.testerAction.any(finder);

  await warp.testerAction.pumpAndSettle();
}
