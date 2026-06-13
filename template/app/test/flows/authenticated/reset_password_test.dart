//
// ignore_for_file: lines_longer_than_80_chars

import 'package:flow_test/flow_test.dart';
import 'package:flutter_test/flutter_test.dart' hide expect;
import 'package:gadfly_flutter_template/inside/blocs/reset_password/events.dart';
import 'package:gadfly_flutter_template/inside/routes/authenticated/home/page.dart';
import 'package:gadfly_flutter_template/inside/routes/authenticated/reset_password/widgets/button_submit.dart';
import 'package:gadfly_flutter_template/inside/routes/authenticated/reset_password/widgets/input_email.dart';
import 'package:mocktail/mocktail.dart';

import '../../util/flow_config.dart';
import 'epic_description.dart';

void main() {
  final baseDescriptions = [
    epicDescription_authenticated,
    FTDescription(
      descriptionType: 'STORY',
      directoryName: 'reset_password',
      description:
          '''As a user, I should be able to reset my password.''',
      atScreenshotsLevel: true,
    ),
  ];

  flowTest(
    'success',
    config: createFlowConfig(
      hasAccessToken: true,
      deepLinkOverride: '/home/reset-password',
    ),
    descriptions: [
      ...baseDescriptions,
      FTDescription(
        descriptionType: 'AC',
        directoryName: 'success',
        description: '''Resetting the password is successful''',
      ),
    ],
    test: (tester) async {
      await tester.setUp();

      await tester.screenshot(
        description: 'initial state',
        actions: (actions) async {
          await actions.testerAction.pumpAndSettle();
        },
        expectedEvents: [
          '[app_builder] INFO: locale: en',
          '[routes_deep_link_handler] INFO: incoming deep link uri: /',
          '[ANALYTIC] [page]: Home_Route',
          '[ANALYTIC] [page]: ResetPassword_Route',
        ],
      );

      await tester.screenshot(
        description: 'enter password',
        actions: (actions) async {
          await actions.userAction.enterText(
            find.byType(ResetPassword_Input_Password),
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
            () => arrange.mocks.repositories.authRepository.resetPassword(
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) async {});
        },
        actions: (actions) async {
          await actions.userAction.tap(
            find.byType(ResetPassword_Button_Submit),
          );
          await actions.testerAction.pumpAndSettle();
        },
        expectations: (expectations) {
          expectations.expect(
            find.byType(Home_Page),
            findsOneWidget,
            reason: 'Should be on the home page',
          );
          expectations.expect(
            find.text('Your password was reset.'),
            findsOneWidget,
            reason: 'Should see success snack bar',
          );
        },
        expectedEvents: [
          '[reset_password_form_reset_password] INFO: submitting form',
          '[reset_password_form_reset_password] INFO: form valid',
          ResetPassword_Event_ResetPassword,
          '[ANALYTIC] page_popped: ResetPassword_Route',
        ],
      );
    },
  );

  group('failure', () {
    final failureDescription = FTDescription(
      descriptionType: 'AC',
      directoryName: 'failure',
      description: '''Resetting the password failed''',
    );

    flowTest(
      'password_empty',
      config: createFlowConfig(
        hasAccessToken: true,
        deepLinkOverride: '/home/reset-password',
      ),
      descriptions: [
        ...baseDescriptions,
        failureDescription,
        FTDescription(
          descriptionType: 'scenario',
          directoryName: 'password_empty',
          description: '''The password is empty''',
        ),
      ],
      test: (tester) async {
        await tester.setUp();

        await tester.screenshot(
          description: 'initial state',
          actions: (actions) async {
            await actions.testerAction.pumpAndSettle();
          },
          expectedEvents: [
            '[app_builder] INFO: locale: en',
            '[routes_deep_link_handler] INFO: incoming deep link uri: /',
            '[ANALYTIC] [page]: Home_Route',
            '[ANALYTIC] [page]: ResetPassword_Route',
          ],
        );

        await tester.screenshot(
          description: 'tap submit',
          actions: (actions) async {
            await actions.userAction.tap(
              find.byType(ResetPassword_Button_Submit),
            );
            await actions.testerAction.pumpAndSettle();
          },
          expectations: (expectations) {
            expectations.expect(
              find.text('Please enter a password.'),
              findsOneWidget,
              reason: 'Should see password empty error',
            );
          },
          expectedEvents: [
            '[reset_password_form_reset_password] INFO: submitting form',
            '[reset_password_form_reset_password] WARNING: form not valid',
          ],
        );
      },
    );

    flowTest(
      'password_invalid',
      config: createFlowConfig(
        hasAccessToken: true,
        deepLinkOverride: '/home/reset-password',
      ),
      descriptions: [
        ...baseDescriptions,
        failureDescription,
        FTDescription(
          descriptionType: 'scenario',
          directoryName: 'password_invalid',
          description: '''The password is too weak''',
        ),
      ],
      test: (tester) async {
        await tester.setUp();

        await tester.screenshot(
          description: 'initial state',
          actions: (actions) async {
            await actions.testerAction.pumpAndSettle();
          },
          expectedEvents: [
            '[app_builder] INFO: locale: en',
            '[routes_deep_link_handler] INFO: incoming deep link uri: /',
            '[ANALYTIC] [page]: Home_Route',
            '[ANALYTIC] [page]: ResetPassword_Route',
          ],
        );

        await tester.screenshot(
          description: 'enter password',
          actions: (actions) async {
            await actions.userAction.enterText(
              find.byType(ResetPassword_Input_Password),
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
            await actions.userAction.tap(
              find.byType(ResetPassword_Button_Submit),
            );
            await actions.testerAction.pumpAndSettle();
          },
          expectations: (expectations) {
            expectations.expect(
              find.text(
                'Minimum 8 characters, upper and lower case, with at least one special character.',
              ),
              findsOneWidget,
              reason: 'Should see password invalid error',
            );
          },
          expectedEvents: [
            '[reset_password_form_reset_password] INFO: submitting form',
            '[reset_password_form_reset_password] WARNING: form not valid',
          ],
        );
      },
    );

    flowTest(
      'http_error',
      config: createFlowConfig(
        hasAccessToken: true,
        deepLinkOverride: '/home/reset-password',
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
        await tester.setUp();

        await tester.screenshot(
          description: 'initial state',
          actions: (actions) async {
            await actions.testerAction.pumpAndSettle();
          },
          expectedEvents: [
            '[app_builder] INFO: locale: en',
            '[routes_deep_link_handler] INFO: incoming deep link uri: /',
            '[ANALYTIC] [page]: Home_Route',
            '[ANALYTIC] [page]: ResetPassword_Route',
          ],
        );

        await tester.screenshot(
          description: 'enter password',
          actions: (actions) async {
            await actions.userAction.enterText(
              find.byType(ResetPassword_Input_Password),
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
              () => arrange.mocks.repositories.authRepository.resetPassword(
                password: any(named: 'password'),
              ),
            ).thenThrow(Exception('BOOM'));
          },
          actions: (actions) async {
            await actions.userAction.tap(
              find.byType(ResetPassword_Button_Submit),
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
            '[reset_password_form_reset_password] INFO: submitting form',
            '[reset_password_form_reset_password] INFO: form valid',
            ResetPassword_Event_ResetPassword,
            '[reset_password_bloc] WARNING: ResetPassword_Event_ResetPassword: error',
          ],
        );
      },
    );
  });
}
