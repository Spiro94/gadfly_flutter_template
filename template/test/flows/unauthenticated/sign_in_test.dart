import 'package:flow_test/flow_test.dart';
import 'package:flutter_test/flutter_test.dart' hide expect;
import 'package:gadfly_flutter_template/blocs/auth/event.dart';
import 'package:gadfly_flutter_template/blocs/sign_in/event.dart';
import 'package:gadfly_flutter_template/pages/authenticated/home/page.dart';
import 'package:gadfly_flutter_template/pages/unauthenticated/sign_in/page.dart';
import 'package:gadfly_flutter_template/pages/unauthenticated/sign_in/widgets/connector/email_text_field.dart';
import 'package:gadfly_flutter_template/pages/unauthenticated/sign_in/widgets/connector/password_text_field.dart';
import 'package:gadfly_flutter_template/pages/unauthenticated/sign_in/widgets/connector/sign_in_button.dart';
import 'package:gadfly_flutter_template/shared/widgets/dumb/button.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import '../../util/fake/auth_change_effect.dart';
import '../../util/fake/supabase_user.dart';
import '../../util/util.dart';

void main() {
  final baseDescriptions = [
    FTDescription(
      descriptionType: 'EPIC',
      shortDescription: 'unauthenticated',
      description:
          '''As a user, I need to be able to interact with the appication when I am unauthenticated.''',
    ),
    FTDescription(
      descriptionType: 'STORY',
      shortDescription: 'sign_in',
      description:
          '''As a user, I should be able to sign in to the application, so that I can use it.''',
      atScreenshotsLevel: true,
    ),
  ];

  group('Happy Path', () {
    final happyPathDescription = FTDescription(
      descriptionType: 'PATH',
      shortDescription: 'happy_path',
      description: '''Happy Path: Signing in is successful''',
    );

    flowTest(
      'HP1',
      config: createFlowConfig(
        hasAccessToken: false,
      ),
      descriptions: [
        ...baseDescriptions,
        happyPathDescription,
        FTDescription(
          descriptionType: 'AC',
          shortDescription: 'tapping_inputs',
          description:
              '''There are two ways to fill out the form. This covers manually tapping into each input.''',
        ),
      ],
      test: (tester) async {
        await tester.setUp(
          arrangeBeforePumpApp: (arrange) async {
            final fakeAuthChangeEffect = FakeAuthChangeEffect();
            when(() => arrange.mocks.authChangeEffectProvider.getEffect())
                .thenAnswer(
              (invocation) => fakeAuthChangeEffect,
            );

            arrange.extras['fakeAuthChangeEffect'] = fakeAuthChangeEffect;
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
          expectedEvents: [
            'Page: SignIn',
          ],
        );

        await tester.screenshot(
          description: 'enter email',
          actions: (actions) async {
            await actions.userAction.enterText(
              find.byType(SignInC_EmailTextField),
              'foo@example.com',
            );
            await actions.testerAction.pumpAndSettle();
          },
        );

        await tester.screenshot(
          description: 'enter password',
          actions: (actions) async {
            await actions.userAction.enterText(
              find.byType(SignInC_PasswordTextField),
              'Pass123!',
            );
            await actions.testerAction.pumpAndSettle();
          },
        );

        await tester.screenshot(
          description: 'tap submit button (pump half)',
          arrangeBeforeActions: (arrange) {
            when(
              () => arrange.mocks.authRepository.signIn(
                email: any(named: 'email'),
                password: any(named: 'password'),
              ),
            ).thenAnswer((invocation) async {
              await Future<void>.delayed(const Duration(seconds: 500));
              final fakeAuthChangeEffect = arrange
                  .extras['fakeAuthChangeEffect'] as FakeAuthChangeEffect;
              fakeAuthChangeEffect.streamController?.add(
                supabase.AuthState(
                  supabase.AuthChangeEvent.signedIn,
                  supabase.Session(
                    accessToken: 'fakeAccessToken',
                    tokenType: '',
                    user: FakeSupabaseUser(),
                  ),
                ),
              );
              return;
            });
          },
          actions: (actions) async {
            await actions.userAction.tap(find.byType(SignInC_SignInButton));
            await actions.testerAction.pump(const Duration(milliseconds: 250));
          },
          expectations: (expectations) {
            expectations.expect(
              find.byType(LoadingIndicator),
              findsOneWidget,
              reason: 'Should see a loading indicator',
            );
            expectations.expect(
              find.byType(Home_Page),
              findsNothing,
              reason: 'Should not be on the Home page yet',
            );
          },
          expectedEvents: [
            SignInEvent_SignIn,
          ],
        );

        await tester.screenshot(
          description: 'tap submit button (pump rest)',
          actions: (actions) async {
            await actions.testerAction.pumpAndSettle();
          },
          expectations: (expectations) {
            expectations.expect(
              find.byType(Home_Page),
              findsOneWidget,
              reason: 'Should be on the Home page',
            );
          },
          expectedEvents: [
            'INFO: [auth_change_subscription] signedIn',
            AuthEvent_AccessTokenAdded,
            'Page: Home',
          ],
        );
      },
    );

    flowTest(
      'HP2',
      config: createFlowConfig(hasAccessToken: false),
      descriptions: [
        ...baseDescriptions,
        happyPathDescription,
        FTDescription(
          descriptionType: 'AC',
          shortDescription: 'pressing_enter',
          description:
              '''There are two ways to fill out the form. This covers pressing enter to jump to the next input.''',
        ),
      ],
      test: (tester) async {
        await tester.setUp(
          arrangeBeforePumpApp: (arrange) async {
            final fakeAuthChangeEffect = FakeAuthChangeEffect();
            when(() => arrange.mocks.authChangeEffectProvider.getEffect())
                .thenAnswer(
              (invocation) => fakeAuthChangeEffect,
            );
            arrange.extras['fakeAuthChangeEffect'] = fakeAuthChangeEffect;
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
          expectedEvents: [
            'Page: SignIn',
          ],
        );

        await tester.screenshot(
          description: 'enter email',
          actions: (actions) async {
            await actions.userAction.enterText(
              find.byType(SignInC_EmailTextField),
              'foo@example.com',
            );
            await actions.testerAction.pumpAndSettle();
          },
        );

        await tester.screenshot(
          description: 'press enter',
          actions: (actions) async {
            await actions.userAction.testTextInputReceiveNext();
            await actions.testerAction.pumpAndSettle();
          },
        );

        await tester.screenshot(
          description: 'enter password',
          actions: (actions) async {
            await actions.userAction.testTextInputEnterText('password');
            await actions.testerAction.pumpAndSettle();
          },
        );

        await tester.screenshot(
          description: 'press enter (pump half)',
          arrangeBeforeActions: (arrange) {
            when(
              () => arrange.mocks.authRepository.signIn(
                email: any(named: 'email'),
                password: any(named: 'password'),
              ),
            ).thenAnswer((invocation) async {
              await Future<void>.delayed(const Duration(seconds: 500));
              final fakeAuthChangeEffect = arrange
                  .extras['fakeAuthChangeEffect'] as FakeAuthChangeEffect;
              fakeAuthChangeEffect.streamController?.add(
                supabase.AuthState(
                  supabase.AuthChangeEvent.signedIn,
                  supabase.Session(
                    accessToken: 'fakeAccessToken',
                    tokenType: '',
                    user: FakeSupabaseUser(),
                  ),
                ),
              );

              return;
            });
          },
          actions: (actions) async {
            await actions.userAction.testTextInputReceiveDone();
            await actions.testerAction.pump(const Duration(milliseconds: 250));
          },
          expectations: (expectations) {
            expectations.expect(
              find.byType(LoadingIndicator),
              findsOneWidget,
              reason: 'Should see a loading indicator',
            );
            expectations.expect(
              find.byType(Home_Page),
              findsNothing,
              reason: 'Should not be on the Home page yet',
            );
          },
          expectedEvents: [
            SignInEvent_SignIn,
          ],
        );

        await tester.screenshot(
          description: 'press enter (pump rest)',
          actions: (actions) async {
            await actions.testerAction.pumpAndSettle();
          },
          expectations: (expectations) {
            expectations.expect(
              find.byType(Home_Page),
              findsOneWidget,
              reason: 'Should be on the Home page',
            );
          },
          expectedEvents: [
            'INFO: [auth_change_subscription] signedIn',
            AuthEvent_AccessTokenAdded,
            'Page: Home',
          ],
        );
      },
    );

    flowTest(
      'HP3',
      config: createFlowConfig(hasAccessToken: true),
      descriptions: [
        ...baseDescriptions,
        happyPathDescription,
        FTDescription(
          descriptionType: 'AC',
          shortDescription: 'already_have_token',
          description:
              '''As a user, if I already have an auth token, I should not see the SignIn page and should go straight to the Home page.''',
        ),
      ],
      test: (tester) async {
        await tester.setUp(
          arrangeBeforePumpApp: (arrange) async {
            final fakeAuthChangeEffect = FakeAuthChangeEffect();
            when(() => arrange.mocks.authChangeEffectProvider.getEffect())
                .thenAnswer(
              (invocation) => fakeAuthChangeEffect,
            );
          },
        );

        await tester.screenshot(
          description: 'initial state',
          actions: (actions) async {
            await actions.testerAction.pump();
          },
          expectations: (expectations) {
            expectations.expect(
              find.byType(Home_Page),
              findsOneWidget,
              reason:
                  '''Should be on the Home page because we have an accessToken in local storage''',
            );
          },
          expectedEvents: [
            'Page: Home',
          ],
        );
      },
    );
  });

  group('Sad Path', () {
    final sadPathDescription = FTDescription(
      descriptionType: 'PATH',
      shortDescription: 'sad_path',
      description: '''Sad Path: Signing in is not successful''',
    );

    flowTest(
      'SP1',
      config: createFlowConfig(hasAccessToken: false),
      descriptions: [
        ...baseDescriptions,
        sadPathDescription,
        FTDescription(
          descriptionType: 'AC',
          shortDescription: 'empty_inputs',
          description:
              '''If either of the inputs are empty, should not be able to tap the sign in button''',
        ),
      ],
      test: (tester) async {
        await tester.setUp(
          arrangeBeforePumpApp: (arrange) async {
            final fakeAuthChangeEffect = FakeAuthChangeEffect();
            when(() => arrange.mocks.authChangeEffectProvider.getEffect())
                .thenAnswer(
              (invocation) => fakeAuthChangeEffect,
            );
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
          expectedEvents: [
            'Page: SignIn',
          ],
        );

        await tester.screenshot(
          description: 'tap submit button',
          actions: (actions) async {
            await actions.userAction.tap(
              find.descendant(
                of: find.byType(SignInC_SignInButton),
                matching: find.byWidgetPredicate((widget) {
                  if (widget is SharedD_Button) {
                    return widget.status == SharedD_Button_Status.disabled;
                  }
                  return false;
                }),
              ),
            );
            await actions.testerAction.pumpAndSettle();
          },
          expectations: (expectations) {
            expectations.expect(
              find.byType(SignIn_Page),
              findsOneWidget,
              reason: 'Should still be on SignIn page',
            );
          },
          expectedEvents: [],
        );
      },
    );

    flowTest(
      'SP2',
      config: createFlowConfig(hasAccessToken: false),
      descriptions: [
        ...baseDescriptions,
        sadPathDescription,
        FTDescription(
          descriptionType: 'AC',
          shortDescription: 'invalid_email',
          description:
              '''If you attempt to sign in, but the email is invalid, should see invalid error''',
        ),
      ],
      test: (tester) async {
        await tester.setUp(
          arrangeBeforePumpApp: (arrange) async {
            final fakeAuthChangeEffect = FakeAuthChangeEffect();
            when(() => arrange.mocks.authChangeEffectProvider.getEffect())
                .thenAnswer(
              (invocation) => fakeAuthChangeEffect,
            );
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
          expectedEvents: [
            'Page: SignIn',
          ],
        );

        await tester.screenshot(
          description: 'enter invalid emaill address',
          actions: (actions) async {
            await actions.userAction.enterText(
              find.byType(SignInC_EmailTextField),
              'bad email',
            );
            await actions.testerAction.pumpAndSettle();
          },
        );

        await tester.screenshot(
          description: 'enter password',
          actions: (actions) async {
            await actions.userAction.enterText(
              find.byType(SignInC_PasswordTextField),
              'password',
            );
            await actions.testerAction.pumpAndSettle();
          },
        );

        await tester.screenshot(
          description: 'tap submit button',
          actions: (actions) async {
            await actions.userAction.tap(
              find.descendant(
                of: find.byType(SignInC_SignInButton),
                matching: find.byWidgetPredicate((widget) {
                  if (widget is SharedD_Button) {
                    return widget.status == SharedD_Button_Status.enabled;
                  }
                  return false;
                }),
              ),
            );
            await actions.testerAction.pumpAndSettle();
          },
          expectations: (expectations) {
            expectations.expect(
              find.byType(SignIn_Page),
              findsOneWidget,
              reason: 'Should still be on SignIn page',
            );
            expectations.expect(
              find.text('Please enter a valid email address.'),
              findsOneWidget,
              reason: 'Should see email invalid error',
            );
          },
        );
      },
    );

    flowTest(
      'SP3',
      config: createFlowConfig(hasAccessToken: false),
      descriptions: [
        ...baseDescriptions,
        sadPathDescription,
        FTDescription(
          descriptionType: 'AC',
          shortDescription: 'http_error',
          description:
              '''As a user, even if I fill out the form correctly, I can still hit an http error. If this happens, I should be made aware that something went wrong.''',
        ),
      ],
      test: (tester) async {
        await tester.setUp(
          arrangeBeforePumpApp: (arrange) async {
            final fakeAuthChangeEffect = FakeAuthChangeEffect();
            when(() => arrange.mocks.authChangeEffectProvider.getEffect())
                .thenAnswer(
              (invocation) => fakeAuthChangeEffect,
            );
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
          expectedEvents: [
            'Page: SignIn',
          ],
        );

        await tester.screenshot(
          description: 'enter email',
          actions: (actions) async {
            await actions.userAction.enterText(
              find.byType(SignInC_EmailTextField),
              'foo@example.com',
            );
            await actions.testerAction.pumpAndSettle();
          },
        );

        await tester.screenshot(
          description: 'enter password',
          actions: (actions) async {
            await actions.userAction.enterText(
              find.byType(SignInC_PasswordTextField),
              'password',
            );
            await actions.testerAction.pumpAndSettle();
          },
        );

        await tester.screenshot(
          description: 'tap submit button',
          arrangeBeforeActions: (arrange) {
            when(
              () => arrange.mocks.authRepository.signIn(
                email: any(named: 'email'),
                password: any(named: 'password'),
              ),
            ).thenThrow(
              (invocation) async => Exception('BOOM'),
            );
          },
          actions: (actions) async {
            await actions.userAction.tap(find.byType(SignInC_SignInButton));
            await actions.testerAction.pumpAndSettle();
          },
          expectations: (expectations) {
            expectations.expect(
              find.byType(Home_Page),
              findsNothing,
              reason:
                  'Should not be on the Home page because signing in failed',
            );
            expectations.expect(
              find.byType(SignIn_Page),
              findsOneWidget,
              reason: 'Should still be on SignIn page',
            );
            expectations.expect(
              find.text('Could not sign in.'),
              findsOneWidget,
              reason:
                  '''Should see error message letting user know something went wrong.''',
            );
          },
          expectedEvents: [
            SignInEvent_SignIn,
          ],
        );
      },
    );
  });
}
