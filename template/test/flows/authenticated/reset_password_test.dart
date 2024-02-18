import 'package:flow_test/flow_test.dart';
import 'package:flutter_test/flutter_test.dart' hide expect;
import 'package:gadfly_flutter_template/blocs/auth/event.dart';
import 'package:gadfly_flutter_template/blocs/reset_password/event.dart';
import 'package:gadfly_flutter_template/pages/authenticated/home/page.dart';
import 'package:gadfly_flutter_template/pages/authenticated/reset_password/page.dart';
import 'package:gadfly_flutter_template/pages/authenticated/reset_password/widgets/connector/new_password_text_field.dart';
import 'package:gadfly_flutter_template/pages/authenticated/reset_password/widgets/connector/reset_password_button.dart';
import 'package:mocktail/mocktail.dart';
import '../../util/util.dart';
import '../../util/warp/to_home.dart';

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
      shortDescription: 'reset_password',
      description: '''As a user, I should be able to reset my password.''',
      atScreenshotsLevel: true,
    ),
  ];

  group('Reset password', () {
    final happyPathDescription = FTDescription(
      descriptionType: 'AC',
      shortDescription: 'reset_password',
      description: '''Reset Password''',
    );

    flowTest(
      'success1',
      config: createFlowConfig(
        hasAccessToken: false,
        deepLinkOverride: '/deep/resetPassword',
      ),
      descriptions: [
        ...baseDescriptions,
        happyPathDescription,
        FTDescription(
          descriptionType: 'STATUS',
          shortDescription: 'success',
          description: '''Is successful''',
        ),
        FTDescription(
          descriptionType: 'SUBMIT',
          shortDescription: 'by_tap',
          description: '''tap submit''',
        ),
      ],
      test: (tester) async {
        await tester.setUp(
          arrangeBeforePumpApp: (arrange) async {
            await arrangeBeforeWarpToHome(arrange);

            registerFallbackValue(Uri());

            when(
              () => arrange.mocks.authRepository.setSessionFromUri(
                uri: any(named: 'uri'),
              ),
            ).thenAnswer((invocation) async => 'fakeAccessToken');
          },
        );

        await tester.screenshot(
          description: 'initial state',
          actions: (actions) async {
            await actions.testerAction.pumpAndSettle();
          },
          expectations: (expectations) {
            expectations.expect(
              find.byType(ResetPassword_Page),
              findsOneWidget,
              reason: 'Should be on ResetPage page',
            );
          },
          expectedEvents: [
            AuthEvent_SetSessionFromDeepLink,
            'Page: Home',
            'Page: ResetPassword',
          ],
        );

        await tester.screenshot(
          description: 'enter password',
          actions: (actions) async {
            await actions.userAction.enterText(
              find.byType(ResetPasswordC_NewPasswordTextField),
              'Pass123!',
            );
            await actions.testerAction.pumpAndSettle();
          },
          expectations: (expectations) {
            expectations.expect(
              find.text('Pass123!'),
              findsOneWidget,
              reason: 'Should see obfuscated password.',
            );
          },
          expectedEvents: [],
        );

        await tester.screenshot(
          description: 'tap submit',
          arrangeBeforeActions: (arrange) {
            when(
              () => arrange.mocks.authRepository
                  .resetPassword(password: any(named: 'password')),
            ).thenAnswer((invocation) async {
              return;
            });
          },
          actions: (actions) async {
            await actions.userAction.tap(
              find.byType(ResetPasswordC_ResetPasswordButton),
            );
            await actions.testerAction.pumpAndSettle();
          },
          expectations: (expectations) {
            expectations.expect(
              find.byType(Home_Page),
              findsOneWidget,
              reason: 'Should be on Home page',
            );
            expectations.expect(
              find.text('Your password was reset.'),
              findsOneWidget,
              reason: 'Should see success message',
            );
          },
          expectedEvents: [
            ResetPasswordEvent_ResetPassword,
            'Page popped: Home',
          ],
        );
      },
    );

    flowTest(
      'success2',
      config: createFlowConfig(
        hasAccessToken: false,
        deepLinkOverride: '/deep/resetPassword',
      ),
      descriptions: [
        ...baseDescriptions,
        happyPathDescription,
        FTDescription(
          descriptionType: 'STATUS',
          shortDescription: 'success',
          description: '''Is successful''',
        ),
        FTDescription(
          descriptionType: 'SUBMIT',
          shortDescription: 'press_enter',
          description: '''press enter''',
        ),
      ],
      test: (tester) async {
        await tester.setUp(
          arrangeBeforePumpApp: (arrange) async {
            await arrangeBeforeWarpToHome(arrange);

            registerFallbackValue(Uri());

            when(
              () => arrange.mocks.authRepository.setSessionFromUri(
                uri: any(named: 'uri'),
              ),
            ).thenAnswer((invocation) async => 'fakeAccessToken');
          },
        );

        await tester.screenshot(
          description: 'initial state',
          actions: (actions) async {
            await actions.testerAction.pumpAndSettle();
          },
          expectations: (expectations) {
            expectations.expect(
              find.byType(ResetPassword_Page),
              findsOneWidget,
              reason: 'Should be on ResetPage page',
            );
          },
          expectedEvents: [
            AuthEvent_SetSessionFromDeepLink,
            'Page: Home',
            'Page: ResetPassword',
          ],
        );

        await tester.screenshot(
          description: 'enter password',
          actions: (actions) async {
            await actions.userAction.enterText(
              find.byType(ResetPasswordC_NewPasswordTextField),
              'Pass123!',
            );
            await actions.testerAction.pumpAndSettle();
          },
          expectations: (expectations) {
            expectations.expect(
              find.text('Pass123!'),
              findsOneWidget,
              reason: 'Should see obfuscated password.',
            );
          },
          expectedEvents: [],
        );

        await tester.screenshot(
          description: 'press enter',
          arrangeBeforeActions: (arrange) {
            when(
              () => arrange.mocks.authRepository
                  .resetPassword(password: any(named: 'password')),
            ).thenAnswer((invocation) async {
              return;
            });
          },
          actions: (actions) async {
            await actions.userAction.testTextInputReceiveNext();
            await actions.testerAction.pumpAndSettle();
          },
          expectations: (expectations) {
            expectations.expect(
              find.byType(Home_Page),
              findsOneWidget,
              reason: 'Should be on Home page',
            );
            expectations.expect(
              find.text('Your password was reset.'),
              findsOneWidget,
              reason: 'Should see success message',
            );
          },
          expectedEvents: [
            ResetPasswordEvent_ResetPassword,
            'Page popped: Home',
          ],
        );
      },
    );

    flowTest(
      'invalid_error',
      config: createFlowConfig(
        hasAccessToken: false,
        deepLinkOverride: '/deep/resetPassword',
      ),
      descriptions: [
        ...baseDescriptions,
        happyPathDescription,
        FTDescription(
          descriptionType: 'STATUS',
          shortDescription: 'invalid_error',
          description: '''password is invalid''',
        ),
      ],
      test: (tester) async {
        await tester.setUp(
          arrangeBeforePumpApp: (arrange) async {
            await arrangeBeforeWarpToHome(arrange);

            registerFallbackValue(Uri());

            when(
              () => arrange.mocks.authRepository.setSessionFromUri(
                uri: any(named: 'uri'),
              ),
            ).thenAnswer((invocation) async => 'fakeAccessToken');
          },
        );

        await tester.screenshot(
          description: 'initial state',
          actions: (actions) async {
            await actions.testerAction.pumpAndSettle();
          },
          expectations: (expectations) {
            expectations.expect(
              find.byType(ResetPassword_Page),
              findsOneWidget,
              reason: 'Should be on ResetPage page',
            );
          },
          expectedEvents: [
            AuthEvent_SetSessionFromDeepLink,
            'Page: Home',
            'Page: ResetPassword',
          ],
        );

        await tester.screenshot(
          description: 'enter password',
          actions: (actions) async {
            await actions.userAction.enterText(
              find.byType(ResetPasswordC_NewPasswordTextField),
              'invalid password',
            );
            await actions.testerAction.pumpAndSettle();
          },
          expectations: (expectations) {
            expectations.expect(
              find.text('invalid password'),
              findsOneWidget,
              reason: 'Should see obfuscated password.',
            );
          },
          expectedEvents: [],
        );

        await tester.screenshot(
          description: 'tap submit',
          actions: (actions) async {
            await actions.userAction.tap(
              find.byType(ResetPasswordC_ResetPasswordButton),
            );
            await actions.testerAction.pumpAndSettle();
          },
          expectations: (expectations) {
            expectations.expect(
              find.byType(ResetPassword_Page),
              findsOneWidget,
              reason: 'Should be on ResetPassword page',
            );
            expectations.expect(
              find.text(
                '''Minimum 8 characters, upper and lower case, with at least one special character.''',
              ),
              findsOneWidget,
              reason: 'Should see invalid error message',
            );
          },
          expectedEvents: [],
        );
      },
    );

    flowTest(
      'http_error',
      config: createFlowConfig(
        hasAccessToken: false,
        deepLinkOverride: '/deep/resetPassword',
      ),
      descriptions: [
        ...baseDescriptions,
        happyPathDescription,
        FTDescription(
          descriptionType: 'STATUS',
          shortDescription: 'http_error',
          description: '''Is http error''',
        ),
      ],
      test: (tester) async {
        await tester.setUp(
          arrangeBeforePumpApp: (arrange) async {
            await arrangeBeforeWarpToHome(arrange);

            registerFallbackValue(Uri());

            when(
              () => arrange.mocks.authRepository.setSessionFromUri(
                uri: any(named: 'uri'),
              ),
            ).thenAnswer((invocation) async => 'fakeAccessToken');
          },
        );

        await tester.screenshot(
          description: 'initial state',
          actions: (actions) async {
            await actions.testerAction.pumpAndSettle();
          },
          expectations: (expectations) {
            expectations.expect(
              find.byType(ResetPassword_Page),
              findsOneWidget,
              reason: 'Should be on ResetPage page',
            );
          },
          expectedEvents: [
            AuthEvent_SetSessionFromDeepLink,
            'Page: Home',
            'Page: ResetPassword',
          ],
        );

        await tester.screenshot(
          description: 'enter password',
          actions: (actions) async {
            await actions.userAction.enterText(
              find.byType(ResetPasswordC_NewPasswordTextField),
              'Pass123!',
            );
            await actions.testerAction.pumpAndSettle();
          },
          expectations: (expectations) {
            expectations.expect(
              find.text('Pass123!'),
              findsOneWidget,
              reason: 'Should see obfuscated password.',
            );
          },
          expectedEvents: [],
        );

        await tester.screenshot(
          description: 'tap submit',
          arrangeBeforeActions: (arrange) {
            when(
              () => arrange.mocks.authRepository
                  .resetPassword(password: any(named: 'password')),
            ).thenThrow(Exception('BOOM'));
          },
          actions: (actions) async {
            await actions.userAction.tap(
              find.byType(ResetPasswordC_ResetPasswordButton),
            );
            await actions.testerAction.pumpAndSettle();
          },
          expectations: (expectations) {
            expectations.expect(
              find.byType(ResetPassword_Page),
              findsOneWidget,
              reason: 'Should be on ResetPassword page',
            );
            expectations.expect(
              find.text('Your password was not reset.'),
              findsOneWidget,
              reason: 'Should see error message',
            );
          },
          expectedEvents: [
            ResetPasswordEvent_ResetPassword,
          ],
        );
      },
    );
  });
}
