import 'package:flow_test/flow_test.dart';
import 'package:flutter_test/flutter_test.dart' hide expect;
import 'package:gadfly_flutter_template/inside/blocs/auth/events.dart';
import 'package:gadfly_flutter_template/inside/blocs/sign_in/events.dart';
import 'package:gadfly_flutter_template/inside/routes/authenticated/home/page.dart';
import 'package:gadfly_flutter_template/inside/routes/unauthenitcated/sign_in/widgets/button_submit.dart';
import 'package:gadfly_flutter_template/inside/routes/unauthenitcated/sign_in/widgets/input_email.dart';
import 'package:gadfly_flutter_template/inside/routes/unauthenitcated/sign_in/widgets/input_password.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import '../../util/fakes/supabase_user.dart';
import '../../util/flow_config.dart';
import 'epic_description.dart';

void main() {
  final baseDescriptions = [
    epicDescription_unauthenticated,
    FTDescription(
      descriptionType: 'STORY',
      directoryName: 'sign_in',
      description:
          '''As a user, I should be able to sign into the application.''',
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
        description: '''Signing in is successful''',
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
          '[authenticated_guard] INFO: not authenticated',
          '[ANALYTIC] [page]: SignIn_Route',
        ],
      );

      await tester.screenshot(
        description: 'enter email',
        actions: (actions) async {
          await actions.userAction.enterText(
            find.byType(SignIn_Input_Email),
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
            find.byType(SignIn_Input_Password),
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
            () => arrange.mocks.repositories.authRepository.signIn(
              email: any(named: 'email'),
              password: any(
                named: 'password',
              ),
            ),
          ).thenAnswer((_) async {});
        },
        actions: (actions) async {
          await actions.userAction.tap(find.byType(SignIn_Button_Submit));
          await actions.testerAction.pump();
        },
        expectations: (expectations) {},
        expectedEvents: [
          '[sign_in_form_sign_in] INFO: submitting form',
          '[sign_in_form_sign_in] INFO: form valid',
          SignIn_Event_SignIn,
        ],
      );

      await tester.screenshot(
        description: 'mock auth state change',
        arrangeBeforeActions: (arrange) {
          when(
            () => arrange.mocks.repositories.authRepository
                .updatesUsersInClients(),
          ).thenAnswer((_) async {});

          arrange.mocks.effects.authChangeEffect.streamController?.add(
            supabase.AuthState(
              supabase.AuthChangeEvent.signedIn,
              supabase.Session(
                accessToken: 'fakeAccessToken',
                tokenType: '',
                user: Fake_SupabaseUser(),
              ),
            ),
          );
        },
        actions: (actions) async {
          await actions.testerAction.pumpAndSettle();
        },
        expectations: (expectations) {
          expectations.expect(
            find.byType(Home_Page),
            findsOneWidget,
            reason: 'Should be on the home page',
          );
        },
        expectedEvents: [
          '[routes_listener_supabase_auth_change] INFO: signedIn',
          Auth_Event_AccessTokenAdded,
          '[ANALYTIC] [page]: Home_Route',
        ],
      );
    },
  );

  group('failure', () {
    final failureDescription = FTDescription(
      descriptionType: 'AC',
      directoryName: 'failure',
      description: '''Signing in failed''',
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
        await tester.setUp();

        await tester.screenshot(
          description: 'initial state',
          actions: (actions) async {
            await actions.testerAction.pumpAndSettle();
          },
          expectedEvents: [
            '[app_builder] INFO: locale: en',
            '[routes_deep_link_handler] INFO: incoming deep link uri: /',
            '[authenticated_guard] INFO: not authenticated',
            '[ANALYTIC] [page]: SignIn_Route',
          ],
        );

        await tester.screenshot(
          description: 'tap submit',
          actions: (actions) async {
            await actions.userAction.tap(find.byType(SignIn_Button_Submit));
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
            '[sign_in_form_sign_in] INFO: submitting form',
            '[sign_in_form_sign_in] WARNING: form not valid',
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
        await tester.setUp();

        await tester.screenshot(
          description: 'initial state',
          actions: (actions) async {
            await actions.testerAction.pumpAndSettle();
          },
          expectedEvents: [
            '[app_builder] INFO: locale: en',
            '[routes_deep_link_handler] INFO: incoming deep link uri: /',
            '[authenticated_guard] INFO: not authenticated',
            '[ANALYTIC] [page]: SignIn_Route',
          ],
        );

        await tester.screenshot(
          description: 'enter email',
          actions: (actions) async {
            await actions.userAction.enterText(
              find.byType(SignIn_Input_Email),
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
            await actions.userAction.tap(find.byType(SignIn_Button_Submit));
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
            '[sign_in_form_sign_in] INFO: submitting form',
            '[sign_in_form_sign_in] WARNING: form not valid',
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
        await tester.setUp();

        await tester.screenshot(
          description: 'initial state',
          actions: (actions) async {
            await actions.testerAction.pumpAndSettle();
          },
          expectedEvents: [
            '[app_builder] INFO: locale: en',
            '[routes_deep_link_handler] INFO: incoming deep link uri: /',
            '[authenticated_guard] INFO: not authenticated',
            '[ANALYTIC] [page]: SignIn_Route',
          ],
        );

        await tester.screenshot(
          description: 'enter email',
          actions: (actions) async {
            await actions.userAction.enterText(
              find.byType(SignIn_Input_Email),
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
              find.byType(SignIn_Input_Password),
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
              () => arrange.mocks.repositories.authRepository.signIn(
                email: any(named: 'email'),
                password: any(
                  named: 'password',
                ),
              ),
            ).thenThrow(Exception('BOOM'));
          },
          actions: (actions) async {
            await actions.userAction.tap(find.byType(SignIn_Button_Submit));
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
            '[sign_in_form_sign_in] INFO: submitting form',
            '[sign_in_form_sign_in] INFO: form valid',
            SignIn_Event_SignIn,
            '[sign_in_bloc] WARNING: SignIn_Event_SignIn: error',
          ],
        );
      },
    );
  });
}
