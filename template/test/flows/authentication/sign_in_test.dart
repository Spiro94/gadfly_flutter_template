import 'package:flow_test/flow_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart' hide expect;
import 'package:gadfly_flutter_template/blocs/auth/event.dart';
import 'package:gadfly_flutter_template/pages/authenticated/home/page.dart';
import 'package:gadfly_flutter_template/pages/unauthenticated/sign_in/page.dart';
import 'package:gadfly_flutter_template/pages/unauthenticated/sign_in/widgets/connector/exception_button.dart';
import 'package:gadfly_flutter_template/pages/unauthenticated/sign_in/widgets/connector/sign_in_fail_button.dart';
import 'package:gadfly_flutter_template/pages/unauthenticated/sign_in/widgets/connector/sign_in_success_button.dart';
import 'package:mocktail/mocktail.dart';

import '../../util/util.dart';

void main() {
  final baseDescriptions = [
    FTDescription(
      descriptionType: 'EPIC',
      shortDescription: 'authentication',
      description: '''As a user, I can be authenticated or unauthenticated.''',
    ),
    FTDescription(
      descriptionType: 'STORY',
      shortDescription: 'sign_in',
      description:
          '''As a user, I should be able to sign in to the application, so that I can become authenticated.''',
      atScreenshotsLevel: true,
    ),
  ];

  flowTest(
    'AC1',
    config: createFlowConfig(),
    descriptions: [
      ...baseDescriptions,
      FTDescription(
        descriptionType: 'AC',
        shortDescription: 'success',
        description: '''Signing in is successful.''',
      ),
    ],
    test: (tester) async {
      await tester.setUp(
        arrangeBeforePumpApp: (arrange) async {
          await arrange.mocks.sharedPreferencesEffectProvider
              .setMockIntialValue({});
        },
      );

      await tester.screenshot(
        description: 'initial state',
        expectations: (expectations) {
          expectations.expect(
            find.byType(SignIn_Page),
            findsOneWidget,
            reason: 'Should be on the SignIn page',
          );
        },
        expectedEvents: ['Page: SignIn'],
      );

      await tester.screenshot(
        description: 'tap `SignIn (Success)` button',
        arrangeBeforeActions: (arrange) {
          when(
            () => arrange.mocks.authRepository
                .fakeSignIn(shouldFail: any(named: 'shouldFail')),
          ).thenAnswer(
            (invocation) async {
              return 'fakeToken';
            },
          );

          when(() => arrange.mocks.nowEffectProvider.getEffect())
              .thenReturn(FakeNowEffect());
        },
        actions: (actions) async {
          await actions.userAction
              .tap(find.byType(SignInC_SignInSuccessButton));
          await actions.testerAction.pumpAndSettle();
        },
        expectations: (expectations) {
          expectations.expect(
            find.byType(Home_Page),
            findsOneWidget,
            reason: 'Should be on Home page',
          );
          expectations.expect(
            find.text('Signed in on: 1/1/1970'),
            findsOneWidget,
            reason: 'Should see timestamp of when user signed in',
          );
        },
        expectedEvents: [
          AuthEvent_SignIn,
          'Track: Sign In: Attemped',
          'Track: Sign In: Succeeded',
          'Page: Home'
        ],
      );
    },
  );

  flowTest(
    'AC2',
    config: createFlowConfig(),
    descriptions: [
      ...baseDescriptions,
      FTDescription(
        descriptionType: 'AC',
        shortDescription: 'fails',
        description: '''Signing in fails.''',
      ),
    ],
    test: (tester) async {
      await tester.setUp(
        arrangeBeforePumpApp: (arrange) async {
          when(arrange.mocks.nowEffectProvider.getEffect)
              .thenReturn(FakeNowEffect());

          await arrange.mocks.sharedPreferencesEffectProvider
              .setMockIntialValue({});
        },
      );
      await tester.screenshot(
        description: 'initial state',
        expectations: (expectations) async {
          expectations.expect(
            find.byType(SignIn_Page),
            findsOneWidget,
            reason: 'Should be on the SignIn page',
          );
        },
        expectedEvents: ['Page: SignIn'],
      );

      await tester.screenshot(
        description: 'tap `SignIn (Fail)` button',
        arrangeBeforeActions: (arrange) {
          when(
            () => arrange.mocks.authRepository
                .fakeSignIn(shouldFail: any(named: 'shouldFail')),
          ).thenThrow(Exception('BOOM'));
        },
        actions: (actions) async {
          await actions.userAction.tap(find.byType(SignInC_SignInFailButton));
          await actions.testerAction.pumpAndSettle();
        },
        expectations: (expectations) {
          expectations.expect(
            find.byType(Home_Page),
            findsNothing,
            reason: 'Should NOT be on Home page',
          );
          expectations.expect(
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

  flowTest(
    'AC3',
    config: createFlowConfig(),
    descriptions: [
      ...baseDescriptions,
      FTDescription(
        descriptionType: 'AC',
        shortDescription: 'unhandled_exception',
        description: 'Signing in can hit an unhandled exception',
      ),
    ],
    test: (tester) async {
      await tester.setUp(
        arrangeBeforePumpApp: (arrange) async {
          await arrange.mocks.sharedPreferencesEffectProvider
              .setMockIntialValue({});
        },
      );
      await tester.screenshot(
        description: 'initial state',
        expectations: (expectations) async {
          expectations.expect(
            find.byType(SignIn_Page),
            findsOneWidget,
            reason: 'Should be on the SignIn page',
          );
        },
        expectedEvents: ['Page: SignIn'],
      );

      await tester.screenshot(
        description: 'tap `Unhandled Exception` button',
        actions: (actions) async {
          await actions.userAction.tap(find.byType(SignInC_ExceptionButton));
          await actions.testerAction.pumpAndSettle();

          // This exception will get sent to Sentry
          actions.testerAction.takeException();
        },
      );
    },
  );
}
