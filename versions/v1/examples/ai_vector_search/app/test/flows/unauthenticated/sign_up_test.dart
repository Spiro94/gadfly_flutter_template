import 'package:ai_vector_search/blocs/auth/event.dart';
import 'package:ai_vector_search/blocs/sign_up/event.dart';
import 'package:ai_vector_search/pages/authenticated/home/page.dart';
import 'package:ai_vector_search/pages/unauthenticated/sign_up/page.dart';
import 'package:ai_vector_search/pages/unauthenticated/sign_up/widgets/connector/email_text_field.dart';
import 'package:ai_vector_search/pages/unauthenticated/sign_up/widgets/connector/password_text_field.dart';
import 'package:ai_vector_search/pages/unauthenticated/sign_up/widgets/connector/sign_up_button.dart';
import 'package:flow_test/flow_test.dart';
import 'package:flutter_test/flutter_test.dart' hide expect;
import 'package:loading_indicator/loading_indicator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import '../../util/fake/auth_change_effect.dart';
import '../../util/fake/supabase_user.dart';
import '../../util/util.dart';
import '../../util/warp/to_sign_up.dart';

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
      shortDescription: 'sign_up',
      description:
          '''As a user, I should be able to sign up for the application, so that I can use it.''',
      atScreenshotsLevel: true,
    ),
  ];

  group('Happy Path', () {
    final happyPathDescription = FTDescription(
      descriptionType: 'PATH',
      shortDescription: 'happy_path',
      description: '''Happy Path: Signing up is successful''',
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
          warp: warpToSignUp,
          arrangeBeforePumpApp: arrangeBeforeWarpToSignUp,
        );

        await tester.screenshot(
          description: 'initial state',
          expectations: (expectations) {
            expectations.expect(
              find.byType(SignUp_Page),
              findsOneWidget,
              reason: 'Should be on the SignUp page',
            );
          },
        );

        await tester.screenshot(
          description: 'enter email',
          actions: (actions) async {
            await actions.userAction.enterText(
              find.byType(SignUpC_EmailTextField),
              'foo@example.com',
            );
            await actions.testerAction.pumpAndSettle();
          },
        );

        await tester.screenshot(
          description: 'enter password',
          actions: (actions) async {
            await actions.userAction.enterText(
              find.byType(SignUpC_PasswordTextField),
              'Pass123!',
            );
            await actions.testerAction.pumpAndSettle();
          },
        );

        await tester.screenshot(
          description: 'tap submit button (pump half)',
          arrangeBeforeActions: (arrange) {
            when(
              () => arrange.mocks.authRepository.signUp(
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
            await actions.userAction.tap(find.byType(SignUpC_SignUpButton));
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
            SignUpEvent_SignUp,
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
      config: createFlowConfig(
        hasAccessToken: false,
      ),
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
          warp: warpToSignUp,
          arrangeBeforePumpApp: arrangeBeforeWarpToSignUp,
        );

        await tester.screenshot(
          description: 'initial state',
          expectations: (expectations) {
            expectations.expect(
              find.byType(SignUp_Page),
              findsOneWidget,
              reason: 'Should be on the SignUp page',
            );
          },
        );

        await tester.screenshot(
          description: 'enter email',
          actions: (actions) async {
            await actions.userAction.enterText(
              find.byType(SignUpC_EmailTextField),
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
            await actions.userAction.testTextInputEnterText('Pass123!');
            await actions.testerAction.pumpAndSettle();
          },
        );

        await tester.screenshot(
          description: 'press enter (pump half)',
          arrangeBeforeActions: (arrange) {
            when(
              () => arrange.mocks.authRepository.signUp(
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
            SignUpEvent_SignUp,
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
  });

  group('Sad Path', () {
    final sadPathDescription = FTDescription(
      descriptionType: 'PATH',
      shortDescription: 'sad_path',
      description: '''Sad Path: Signing up is not successful''',
    );

    flowTest(
      'SP1',
      config: createFlowConfig(
        hasAccessToken: false,
      ),
      descriptions: [
        ...baseDescriptions,
        sadPathDescription,
        FTDescription(
          descriptionType: 'AC',
          shortDescription: 'invalid_email',
          description: '''Should see error if invalid email address''',
        ),
      ],
      test: (tester) async {
        await tester.setUp(
          warp: warpToSignUp,
          arrangeBeforePumpApp: arrangeBeforeWarpToSignUp,
        );

        await tester.screenshot(
          description: 'initial state',
          expectations: (expectations) {
            expectations.expect(
              find.byType(SignUp_Page),
              findsOneWidget,
              reason: 'Should be on the SignUp page',
            );
          },
        );

        await tester.screenshot(
          description: 'enter email',
          actions: (actions) async {
            await actions.userAction.enterText(
              find.byType(SignUpC_EmailTextField),
              'bad email',
            );
            await actions.testerAction.pumpAndSettle();
          },
        );

        await tester.screenshot(
          description: 'enter password',
          actions: (actions) async {
            await actions.userAction.enterText(
              find.byType(SignUpC_PasswordTextField),
              'Pass123!',
            );
            await actions.testerAction.pumpAndSettle();
          },
        );

        await tester.screenshot(
          description: 'tap submit button',
          actions: (actions) async {
            await actions.userAction.tap(find.byType(SignUpC_SignUpButton));
            await actions.testerAction.pumpAndSettle();
          },
          expectations: (expectations) {
            expectations.expect(
              find.byType(Home_Page),
              findsNothing,
              reason: 'Should not be on the Home page yet',
            );
            expectations.expect(
              find.text('Please enter a valid email address.'),
              findsOneWidget,
              reason: 'Should see invalid email error',
            );
          },
          expectedEvents: [],
        );
      },
    );

    flowTest(
      'SP2',
      config: createFlowConfig(
        hasAccessToken: false,
      ),
      descriptions: [
        ...baseDescriptions,
        sadPathDescription,
        FTDescription(
          descriptionType: 'AC',
          shortDescription: 'invalid_password',
          description: '''Should see error if invalid password''',
        ),
      ],
      test: (tester) async {
        await tester.setUp(
          warp: warpToSignUp,
          arrangeBeforePumpApp: arrangeBeforeWarpToSignUp,
        );

        await tester.screenshot(
          description: 'initial state',
          expectations: (expectations) {
            expectations.expect(
              find.byType(SignUp_Page),
              findsOneWidget,
              reason: 'Should be on the SignUp page',
            );
          },
        );

        await tester.screenshot(
          description: 'enter email',
          actions: (actions) async {
            await actions.userAction.enterText(
              find.byType(SignUpC_EmailTextField),
              'john@example.com',
            );
            await actions.testerAction.pumpAndSettle();
          },
        );

        await tester.screenshot(
          description: 'enter password',
          actions: (actions) async {
            await actions.userAction.enterText(
              find.byType(SignUpC_PasswordTextField),
              'bad password',
            );
            await actions.testerAction.pumpAndSettle();
          },
        );

        await tester.screenshot(
          description: 'tap submit button',
          actions: (actions) async {
            await actions.userAction.tap(find.byType(SignUpC_SignUpButton));
            await actions.testerAction.pumpAndSettle();
          },
          expectations: (expectations) {
            expectations.expect(
              find.byType(Home_Page),
              findsNothing,
              reason: 'Should not be on the Home page yet',
            );
            expectations.expect(
              find.text(
                '''Minimum 8 characters, upper and lower case, with at least one special character.''',
              ),
              findsOneWidget,
              reason: 'Should see invalid password error',
            );
          },
          expectedEvents: [],
        );
      },
    );
  });
}
