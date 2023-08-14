import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gadfly_flutter_template/blocs/auth/event.dart';
import 'package:gadfly_flutter_template/pages/authenticated/home/page.dart';
import 'package:gadfly_flutter_template/pages/authenticated/home/widgets/connector/sign_out_button.dart';
import 'package:gadfly_flutter_template/pages/unauthenticated/sign_in/page.dart';
import 'package:gadfly_flutter_template/pages/unauthenticated/sign_in/widgets/connector/exception_button.dart';
import 'package:gadfly_flutter_template/pages/unauthenticated/sign_in/widgets/connector/sign_in_fail_button.dart';
import 'package:mocktail/mocktail.dart';

import '../../util/fake/fake_now_effect.dart';
import '../../util/test_flow.dart';

void main() {
  testFlow(
    'As a user, I should be able to sign out',
    setup: (tester, mocks, pumpApp) async {
      when(() => mocks.nowEffectProvider.getEffect())
          .thenReturn(FakeNowEffect());

      await mocks.sharedPreferencesEffectProvider.setMockIntialValue({
        'authToken': 'fakeToken',
      });
      await pumpApp();
    },
    test: (testAction) async {
      await testAction(
        'initial state',
        assertion: () {
          expect(
            find.byType(Home_Page),
            findsOneWidget,
            reason: 'Should be on the Home page if already have an authToken',
          );
        },
      );

      await testAction(
        'tap `Sign Out` button',
        act: (tester) async {
          await tester.tap(find.byType(HomeC_SignOutButton));
          await tester.pumpAndSettle();
        },
        assertion: () {
          expect(
            find.byType(SignIn_Page),
            findsOneWidget,
            reason: 'Should be on SignIn page',
          );
        },
        expectedEvents: [
          AuthEvent_SignOut,
          'Track: Sign Out',
          'Page: SignIn',
        ],
      );
    },
  );

  testFlow(
    'As a user, I should be able to sign in, but it can fail',
    setup: (tester, mocks, pumpApp) async {
      await mocks.sharedPreferencesEffectProvider.setMockIntialValue({});
      await pumpApp();
    },
    test: (testAction) async {
      await testAction(
        'initial state',
        assertion: () {
          expect(
            find.byType(SignIn_Page),
            findsOneWidget,
            reason: 'Should be on the SignIn page',
          );
        },
      );

      await testAction(
        'tap `SignIn (Fail)` button',
        arrange: (mocks) {
          when(
            () => mocks.authRepository
                .fakeSignIn(shouldFail: any(named: 'shouldFail')),
          ).thenThrow(Exception('BOOM'));
        },
        act: (tester) async {
          await tester.tap(find.byType(SignInC_SignInFailButton));
          await tester.pumpAndSettle();
        },
        assertion: () {
          expect(
            find.byType(Home_Page),
            findsNothing,
            reason: 'Should NOT be on Home page',
          );
          expect(
            find.descendant(
              of: find.byType(SnackBar),
              matching: find.text('Could not sign in.'),
            ),
            findsOneWidget,
            reason: 'Should see snackbar with warning that sign in failed',
          );
        },
        expectedEvents: [
          AuthEvent_SignIn,
          'Track: Sign In: Attemped',
          'Track: Sign In: Failed',
        ],
      );
    },
  );

  testFlow(
    'As a user, I can hit an unhandled exception',
    setup: (tester, mocks, pumpApp) async {
      await mocks.sharedPreferencesEffectProvider.setMockIntialValue({});
      await pumpApp();
    },
    test: (testAction) async {
      await testAction(
        'initial state',
        assertion: () {
          expect(
            find.byType(SignIn_Page),
            findsOneWidget,
            reason: 'Should be on the SignIn page',
          );
        },
      );

      await testAction(
        'tap `Unhandled Exception` button',
        act: (tester) async {
          await tester.tap(find.byType(SignInC_ExceptionButton));
          await tester.pumpAndSettle();

          // This exception will get sent to Sentry
          tester.takeException();
        },
      );
    },
  );
}
