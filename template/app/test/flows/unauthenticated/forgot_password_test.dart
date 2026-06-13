//
// ignore_for_file: lines_longer_than_80_chars

import 'package:flow_test/flow_test.dart';
import 'package:flutter_test/flutter_test.dart' hide expect;
import 'package:gadfly_flutter_template/inside/blocs/reset_password/events.dart';
import 'package:gadfly_flutter_template/inside/routes/unauthenticated/forgot_password_flow/forgot_password/widgets/button_submit.dart';
import 'package:gadfly_flutter_template/inside/routes/unauthenticated/forgot_password_flow/forgot_password/widgets/input_email.dart';
import 'package:gadfly_flutter_template/inside/routes/unauthenticated/forgot_password_flow/reset_password_link_sent/page.dart';
import 'package:gadfly_flutter_template/inside/routes/unauthenticated/forgot_password_flow/reset_password_link_sent/widgets/link_resend.dart';
import 'package:mocktail/mocktail.dart';

import '../../util/flow_config.dart';
import '../../util/warps/to_forgot_password.dart';
import '../../util/warps/to_reset_password_link_sent.dart';
import 'epic_description.dart';

void main() {
  // --- Forgot Password form tests ---

  final forgotPasswordDescriptions = [
    epicDescription_unauthenticated,
    FTDescription(
      descriptionType: 'STORY',
      directoryName: 'forgot_password',
      description:
          '''As a user, I should be able to request a password reset link.''',
      atScreenshotsLevel: true,
    ),
  ];

  flowTest(
    'success',
    config: createFlowConfig(hasAccessToken: false),
    descriptions: [
      ...forgotPasswordDescriptions,
      FTDescription(
        descriptionType: 'AC',
        directoryName: 'success',
        description: '''Requesting a reset link is successful''',
      ),
    ],
    test: (tester) async {
      await tester.setUp(
        arrangeBeforePumpApp: arrangeBeforeWarpToForgotPassword,
        warp: warpToForgotPassword,
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
            find.byType(ForgotPassword_Input_Email),
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
        description: 'tap submit',
        arrangeBeforeActions: (arrange) {
          when(
            () => arrange.mocks.repositories.authRepository
                .sendResetPasswordLink(email: any(named: 'email')),
          ).thenAnswer((_) async {});
        },
        actions: (actions) async {
          await actions.userAction.tap(
            find.byType(ForgotPassword_Button_Submit),
          );
          await actions.testerAction.pumpAndSettle();
        },
        expectations: (expectations) {
          expectations.expect(
            find.byType(ResetPasswordLinkSent_Page),
            findsOneWidget,
            reason: 'Should be on the reset password link sent page',
          );
        },
        expectedEvents: [
          '[forgot_password_form_reset_password_request] INFO: submitting form',
          '[forgot_password_form_reset_password_request] INFO: form valid',
          ResetPassword_Event_SendResetPasswordLink,
          '[reset_password_link_sent_guard] INFO: email: foo@example.com',
          '[ANALYTIC] [page]: ResetPasswordLinkSent_Route',
        ],
      );
    },
  );

  group('failure', () {
    final failureDescription = FTDescription(
      descriptionType: 'AC',
      directoryName: 'failure',
      description: '''Requesting a reset link failed''',
    );

    flowTest(
      'email_empty',
      config: createFlowConfig(hasAccessToken: false),
      descriptions: [
        ...forgotPasswordDescriptions,
        failureDescription,
        FTDescription(
          descriptionType: 'scenario',
          directoryName: 'email_empty',
          description: '''The email is empty''',
        ),
      ],
      test: (tester) async {
        await tester.setUp(
          arrangeBeforePumpApp: arrangeBeforeWarpToForgotPassword,
          warp: warpToForgotPassword,
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
          actions: (actions) async {
            await actions.userAction.tap(
              find.byType(ForgotPassword_Button_Submit),
            );
            await actions.testerAction.pumpAndSettle();
          },
          expectations: (expectations) {
            expectations.expect(
              find.text('Please enter your email address.'),
              findsOneWidget,
              reason: 'Should see email empty error',
            );
          },
          expectedEvents: [
            '[forgot_password_form_reset_password_request] INFO: submitting form',
            '[forgot_password_form_reset_password_request] WARNING: form not valid',
          ],
        );
      },
    );

    flowTest(
      'email_invalid',
      config: createFlowConfig(hasAccessToken: false),
      descriptions: [
        ...forgotPasswordDescriptions,
        failureDescription,
        FTDescription(
          descriptionType: 'scenario',
          directoryName: 'email_invalid',
          description: '''The email is invalid''',
        ),
      ],
      test: (tester) async {
        await tester.setUp(
          arrangeBeforePumpApp: arrangeBeforeWarpToForgotPassword,
          warp: warpToForgotPassword,
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
              find.byType(ForgotPassword_Input_Email),
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
            await actions.userAction.tap(
              find.byType(ForgotPassword_Button_Submit),
            );
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
            '[forgot_password_form_reset_password_request] INFO: submitting form',
            '[forgot_password_form_reset_password_request] WARNING: form not valid',
          ],
        );
      },
    );

    flowTest(
      'http_error',
      config: createFlowConfig(hasAccessToken: false),
      descriptions: [
        ...forgotPasswordDescriptions,
        failureDescription,
        FTDescription(
          descriptionType: 'scenario',
          directoryName: 'http_error',
          description: '''There was an http error''',
        ),
      ],
      test: (tester) async {
        await tester.setUp(
          arrangeBeforePumpApp: arrangeBeforeWarpToForgotPassword,
          warp: warpToForgotPassword,
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
              find.byType(ForgotPassword_Input_Email),
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
          description: 'tap submit',
          arrangeBeforeActions: (arrange) {
            when(
              () => arrange.mocks.repositories.authRepository
                  .sendResetPasswordLink(email: any(named: 'email')),
            ).thenThrow(Exception('BOOM'));
          },
          actions: (actions) async {
            await actions.userAction.tap(
              find.byType(ForgotPassword_Button_Submit),
            );
            await actions.testerAction.pumpAndSettle();
          },
          expectations: (expectations) {
            expectations.expect(
              find.text('Something went wrong. Please try again.'),
              findsOneWidget,
              reason: 'Should see snack bar showing localized error message',
            );
          },
          expectedEvents: [
            '[forgot_password_form_reset_password_request] INFO: submitting form',
            '[forgot_password_form_reset_password_request] INFO: form valid',
            ResetPassword_Event_SendResetPasswordLink,
            '[reset_password_bloc] WARNING: ResetPassword_Event_SendResetPasswordLink: error',
          ],
        );
      },
    );
  });

  // --- Reset Password Link Sent page tests ---

  final resetPasswordLinkSentDescriptions = [
    epicDescription_unauthenticated,
    FTDescription(
      descriptionType: 'STORY',
      directoryName: 'reset_password_link_sent',
      description:
          '''As a user, I should be able to resend my reset password link.''',
      atScreenshotsLevel: true,
    ),
  ];

  flowTest(
    'success',
    config: createFlowConfig(hasAccessToken: false),
    descriptions: [
      ...resetPasswordLinkSentDescriptions,
      FTDescription(
        descriptionType: 'AC',
        directoryName: 'success',
        description: '''Resending the link is successful''',
      ),
    ],
    test: (tester) async {
      await tester.setUp(
        arrangeBeforePumpApp: arrangeBeforeWarpToResetPasswordLinkSent,
        warp: warpToResetPasswordLinkSent,
      );

      await tester.screenshot(
        description: 'initial state',
        actions: (actions) async {
          await actions.testerAction.pumpAndSettle();
        },
        expectedEvents: [],
      );

      await tester.screenshot(
        description: 'tap resend',
        arrangeBeforeActions: (arrange) {
          when(
            () => arrange.mocks.repositories.authRepository
                .sendResetPasswordLink(email: any(named: 'email')),
          ).thenAnswer((_) async {});
        },
        actions: (actions) async {
          await actions.userAction.tap(
            find.byType(ResetPasswordLinkSent_Link_Resend),
          );
          await actions.testerAction.pumpAndSettle();
        },
        expectations: (expectations) {
          expectations.expect(
            find.text('Your reset password link was resent.'),
            findsOneWidget,
            reason: 'Should see success snack bar',
          );
        },
        expectedEvents: [ResetPassword_Event_ResendResetPasswordLink],
      );
    },
  );

  group('resend failure', () {
    final resendFailureDescription = FTDescription(
      descriptionType: 'AC',
      directoryName: 'resend_failure',
      description: '''Resending the link failed''',
    );

    flowTest(
      'http_error',
      config: createFlowConfig(hasAccessToken: false),
      descriptions: [
        ...resetPasswordLinkSentDescriptions,
        resendFailureDescription,
        FTDescription(
          descriptionType: 'scenario',
          directoryName: 'http_error',
          description: '''There was an http error''',
        ),
      ],
      test: (tester) async {
        await tester.setUp(
          arrangeBeforePumpApp: arrangeBeforeWarpToResetPasswordLinkSent,
          warp: warpToResetPasswordLinkSent,
        );

        await tester.screenshot(
          description: 'initial state',
          actions: (actions) async {
            await actions.testerAction.pumpAndSettle();
          },
          expectedEvents: [],
        );

        await tester.screenshot(
          description: 'tap resend',
          arrangeBeforeActions: (arrange) {
            when(
              () => arrange.mocks.repositories.authRepository
                  .sendResetPasswordLink(email: any(named: 'email')),
            ).thenThrow(Exception('BOOM'));
          },
          actions: (actions) async {
            await actions.userAction.tap(
              find.byType(ResetPasswordLinkSent_Link_Resend),
            );
            await actions.testerAction.pumpAndSettle();
          },
          expectations: (expectations) {
            expectations.expect(
              find.text('Something went wrong. Please try again.'),
              findsOneWidget,
              reason: 'Should see snack bar showing localized error message',
            );
          },
          expectedEvents: [
            ResetPassword_Event_ResendResetPasswordLink,
            '[reset_password_bloc] WARNING: ResetPassword_Event_ResendResetPasswordLink: error',
          ],
        );
      },
    );
  });
}
