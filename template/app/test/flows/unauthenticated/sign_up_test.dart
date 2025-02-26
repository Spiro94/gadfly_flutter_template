import 'package:flow_test/flow_test.dart';
import 'package:flutter_test/flutter_test.dart' hide expect;
import 'package:forui/forui.dart';
import 'package:gadfly_flutter_template/inside/blocs/sign_up/events.dart';
import 'package:gadfly_flutter_template/inside/routes/unauthenitcated/sign_up/widgets/button_submit.dart';
import 'package:gadfly_flutter_template/inside/routes/unauthenitcated/sign_up/widgets/input_email.dart';
import 'package:gadfly_flutter_template/inside/routes/unauthenitcated/sign_up/widgets/input_password.dart';
import 'package:mocktail/mocktail.dart';

import '../../util/flow_config.dart';
import '../../util/warps/to_sign_up.dart';
import 'epic_description.dart';

void main() {
  final baseDescriptions = [
    epicDescription_unauthenticated,
    FTDescription(
      descriptionType: 'STORY',
      directoryName: 'sign_up',
      description:
          '''As a user, I should be able to sign up for the application.''',
      atScreenshotsLevel: true,
    ),
  ];

  flowTest(
    'success',
    config: createFlowConfig(
      hasAccessToken: false,
    ),
    descriptions: [
      ...baseDescriptions,
      FTDescription(
        descriptionType: 'AC',
        directoryName: 'success',
        description: '''Signing up is successful''',
      ),
    ],
    test: (tester) async {
      await tester.setUp(
        arrangeBeforePumpApp: arrangeBeforeWarpToSignUp,
        warp: warpToSignUp,
      );

      await tester.screenshot(
        description: 'initial state',
        actions: (actions) async {
          await actions.testerAction.pumpAndSettle();
        },
        expectedEvents: [],
      );

      await tester.screenshot(
        description: 'enter email',
        actions: (actions) async {
          await actions.userAction.enterText(
            find.byType(SignUp_Input_Email),
            'foo@example.com',
          );
          await actions.testerAction.pumpAndSettle();
        },
        expectations: (expectations) {
          expectations.expect(
            find.text('foo@example.com', findRichText: true),
            findsOneWidget,
            reason: 'email should be entered',
          );
        },
        expectedEvents: [],
      );

      await tester.screenshot(
        description: 'enter password',
        actions: (actions) async {
          await actions.userAction.enterText(
            find.byType(SignUp_Input_Password),
            'Password123!',
          );
          await actions.testerAction.pumpAndSettle();
        },
        expectations: (expectations) {
          expectations.expect(
            find.text('Password123!', findRichText: true),
            findsOneWidget,
            reason: 'password should be entered',
          );
        },
        expectedEvents: [],
      );

      await tester.screenshot(
        description: 'tap submit',
        arrangeBeforeActions: (arrange) {
          when(
            () => arrange.mocks.repositories.authRepository.signUp(
              email: any(named: 'email'),
              password: any(
                named: 'password',
              ),
            ),
          ).thenAnswer((_) async {});
        },
        actions: (actions) async {
          await actions.userAction.tap(find.byType(SignUp_Button_Submit));
          await actions.testerAction.pumpAndSettle();
        },
        expectations: (expectations) {},
        expectedEvents: [
          '[sign_up_form_sign_up] INFO: submitting form',
          '[sign_up_form_sign_up] INFO: form valid',
          SignUp_Event_SignUp,
          '[ANALYTIC] [page]: EmailVerificationLinkSent_Route',
        ],
      );

      await tester.screenshot(
        description: 'tap back arrow',
        actions: (actions) async {
          await actions.userAction.tap(find.byType(FHeaderAction));
          await actions.testerAction.pumpAndSettle();
        },
        expectations: (expectations) {},
        expectedEvents: [
          '[ANALYTIC] page_popped: EmailVerificationLinkSent_Route',
        ],
      );
    },
  );

  group('failure', () {
    final failureDescription = FTDescription(
      descriptionType: 'AC',
      directoryName: 'failure',
      description: '''Signing up failed''',
    );

    flowTest(
      'email_empty',
      config: createFlowConfig(
        hasAccessToken: false,
      ),
      descriptions: [
        ...baseDescriptions,
        failureDescription,
        FTDescription(
          descriptionType: 'scenario',
          directoryName: 'email_empty',
          description: '''The email is invalid''',
        ),
      ],
      test: (tester) async {
        await tester.setUp(
          arrangeBeforePumpApp: arrangeBeforeWarpToSignUp,
          warp: warpToSignUp,
        );

        await tester.screenshot(
          description: 'initial state',
          actions: (actions) async {
            await actions.testerAction.pumpAndSettle();
          },
          expectedEvents: [],
        );

        await tester.screenshot(
          description: 'tap submit',
          arrangeBeforeActions: (arrange) {
            when(
              () => arrange.mocks.repositories.authRepository.signUp(
                email: any(named: 'email'),
                password: any(
                  named: 'password',
                ),
              ),
            ).thenAnswer((_) async {});
          },
          actions: (actions) async {
            await actions.userAction.tap(find.byType(SignUp_Button_Submit));
            await actions.testerAction.pumpAndSettle();
          },
          expectations: (expectations) {
            expectations.expect(
              find.text('Please enter your email address.'),
              findsOneWidget,
              reason: 'Should see email empty error',
            );
            expectations.expect(
              find.text('Please enter a password.'),
              findsOneWidget,
              reason: 'Should see password empty error',
            );
          },
          expectedEvents: [
            '[sign_up_form_sign_up] INFO: submitting form',
            '[sign_up_form_sign_up] WARNING: form not valid',
          ],
        );
      },
    );

    flowTest(
      'email_invalid',
      config: createFlowConfig(
        hasAccessToken: false,
      ),
      descriptions: [
        ...baseDescriptions,
        failureDescription,
        FTDescription(
          descriptionType: 'scenario',
          directoryName: 'email_invalid',
          description: '''The email is invalid''',
        ),
      ],
      test: (tester) async {
        await tester.setUp(
          arrangeBeforePumpApp: arrangeBeforeWarpToSignUp,
          warp: warpToSignUp,
        );

        await tester.screenshot(
          description: 'initial state',
          actions: (actions) async {
            await actions.testerAction.pumpAndSettle();
          },
          expectedEvents: [],
        );

        await tester.screenshot(
          description: 'enter email',
          actions: (actions) async {
            await actions.userAction.enterText(
              find.byType(SignUp_Input_Email),
              'bad email',
            );
            await actions.testerAction.pumpAndSettle();
          },
          expectations: (expectations) {
            expectations.expect(
              find.text('bad email', findRichText: true),
              findsOneWidget,
              reason: 'email should be entered',
            );
          },
          expectedEvents: [],
        );

        await tester.screenshot(
          description: 'tap submit',
          actions: (actions) async {
            await actions.userAction.tap(find.byType(SignUp_Button_Submit));
            await actions.testerAction.pumpAndSettle();
          },
          expectations: (expectations) {
            expectations.expect(
              find.text('Please enter a valid email address.'),
              findsOneWidget,
              reason: 'Should see invalid email error',
            );
          },
          expectedEvents: [
            '[sign_up_form_sign_up] INFO: submitting form',
            '[sign_up_form_sign_up] WARNING: form not valid',
          ],
        );
      },
    );

    flowTest(
      'password_invalid',
      config: createFlowConfig(
        hasAccessToken: false,
      ),
      descriptions: [
        ...baseDescriptions,
        failureDescription,
        FTDescription(
          descriptionType: 'scenario',
          directoryName: 'password_invalid',
          description: '''The password is invalid''',
        ),
      ],
      test: (tester) async {
        await tester.setUp(
          arrangeBeforePumpApp: arrangeBeforeWarpToSignUp,
          warp: warpToSignUp,
        );

        await tester.screenshot(
          description: 'initial state',
          actions: (actions) async {
            await actions.testerAction.pumpAndSettle();
          },
          expectedEvents: [],
        );

        await tester.screenshot(
          description: 'enter password',
          actions: (actions) async {
            await actions.userAction.enterText(
              find.byType(SignUp_Input_Password),
              'bad password',
            );
            await actions.testerAction.pumpAndSettle();
          },
          expectations: (expectations) {
            expectations.expect(
              find.text('bad password', findRichText: true),
              findsOneWidget,
              reason: 'password should be entered',
            );
          },
          expectedEvents: [],
        );

        await tester.screenshot(
          description: 'tap submit',
          actions: (actions) async {
            await actions.userAction.tap(find.byType(SignUp_Button_Submit));
            await actions.testerAction.pumpAndSettle();
          },
          expectations: (expectations) {
            expectations.expect(
              find.text(
                '''Minimum 8 characters, upper and lower case, with at least one special character.''',
              ),
              findsOneWidget,
              reason: 'Should see invalid email error',
            );
          },
          expectedEvents: [
            '[sign_up_form_sign_up] INFO: submitting form',
            '[sign_up_form_sign_up] WARNING: form not valid',
          ],
        );
      },
    );

    flowTest(
      'http_error',
      config: createFlowConfig(
        hasAccessToken: false,
      ),
      descriptions: [
        ...baseDescriptions,
        failureDescription,
        FTDescription(
          descriptionType: 'scenario',
          directoryName: 'http_error',
          description: '''There was an http error''',
        ),
      ],
      test: (tester) async {
        await tester.setUp(
          arrangeBeforePumpApp: arrangeBeforeWarpToSignUp,
          warp: warpToSignUp,
        );

        await tester.screenshot(
          description: 'initial state',
          actions: (actions) async {
            await actions.testerAction.pumpAndSettle();
          },
          expectedEvents: [],
        );

        await tester.screenshot(
          description: 'enter email',
          actions: (actions) async {
            await actions.userAction.enterText(
              find.byType(SignUp_Input_Email),
              'foo@example.com',
            );
            await actions.testerAction.pumpAndSettle();
          },
          expectations: (expectations) {
            expectations.expect(
              find.text('foo@example.com', findRichText: true),
              findsOneWidget,
              reason: 'email should be entered',
            );
          },
          expectedEvents: [],
        );

        await tester.screenshot(
          description: 'enter password',
          actions: (actions) async {
            await actions.userAction.enterText(
              find.byType(SignUp_Input_Password),
              'Password123!',
            );
            await actions.testerAction.pumpAndSettle();
          },
          expectations: (expectations) {
            expectations.expect(
              find.text('Password123!', findRichText: true),
              findsOneWidget,
              reason: 'password should be entered',
            );
          },
          expectedEvents: [],
        );

        await tester.screenshot(
          description: 'tap submit',
          arrangeBeforeActions: (arrange) {
            when(
              () => arrange.mocks.repositories.authRepository.signUp(
                email: any(named: 'email'),
                password: any(
                  named: 'password',
                ),
              ),
            ).thenThrow(Exception('BOOM'));
          },
          actions: (actions) async {
            await actions.userAction.tap(find.byType(SignUp_Button_Submit));
            await actions.testerAction.pumpAndSettle();
          },
          expectations: (expectations) {
            expectations.expect(
              find.text('Exception: BOOM'),
              findsOneWidget,
              reason: 'Should see snack bar showing exception',
            );
          },
          expectedEvents: [
            '[sign_up_form_sign_up] INFO: submitting form',
            '[sign_up_form_sign_up] INFO: form valid',
            SignUp_Event_SignUp,
            '[sign_up_bloc] WARNING: SignUpEvent_SignUp: error',
          ],
        );
      },
    );
  });
}
