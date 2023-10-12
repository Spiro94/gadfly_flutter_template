import 'package:flow_test/flow_test.dart';
import 'package:flutter_test/flutter_test.dart' hide expect;
import 'package:google_auth/blocs/auth/event.dart';
import 'package:google_auth/blocs/forgot_password/event.dart';
import 'package:google_auth/pages/authenticated/reset_password/page.dart';
import 'package:google_auth/pages/unauthenticated/forgot_flow/forgot_password/page.dart';
import 'package:google_auth/pages/unauthenticated/forgot_flow/forgot_password/widgets/connector/email_text_field.dart';
import 'package:google_auth/pages/unauthenticated/forgot_flow/forgot_password/widgets/connector/reset_password_button.dart';
import 'package:google_auth/pages/unauthenticated/forgot_flow/forgot_password_confirmation/page.dart';
import 'package:google_auth/pages/unauthenticated/forgot_flow/forgot_password_confirmation/widgets/connector/resend_email_button.dart';
import 'package:google_auth/pages/unauthenticated/sign_in/page.dart';

import 'package:loading_indicator/loading_indicator.dart';
import 'package:mocktail/mocktail.dart';

import '../../util/util.dart';
import '../../util/warp/to_forgot_password.dart';
import '../../util/warp/to_forgot_password_confirmation.dart';
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
      shortDescription: 'forgot_password',
      description:
          '''As a user, I should be able to recover my account when I have forgotten my password.''',
      atScreenshotsLevel: true,
    ),
  ];

  group('Happy Path', () {
    final happyPathDescription = FTDescription(
      descriptionType: 'PATH',
      shortDescription: 'happy_path',
      description: '''Happy Path: Forgot password flow is successful''',
    );

    flowTest(
      'HP1.A',
      config: createFlowConfig(
        hasAccessToken: false,
      ),
      descriptions: [
        ...baseDescriptions,
        happyPathDescription,
        FTDescription(
          descriptionType: 'PATH',
          shortDescription: 'path_a',
          description:
              '''The forgot password flow is in two parts, this is the first part, part A''',
        ),
      ],
      test: (tester) async {
        await tester.setUp(
          arrangeBeforePumpApp: arrangeBeforeWarpToForgotPassword,
          warp: warpToForgotPassword,
        );

        await tester.screenshot(
          description: 'initial state',
          expectations: (expectations) {
            expectations.expect(
              find.byType(ForgotPassword_Page),
              findsOneWidget,
              reason: 'Should be on the ForgotPassword page',
            );
          },
        );

        await tester.screenshot(
          description: 'enter email address',
          actions: (actions) async {
            await actions.userAction.enterText(
              find.byType(ForgotPasswordC_EmailTextField),
              'john@example.com',
            );
            await actions.testerAction.pumpAndSettle();
          },
        );

        await tester.screenshot(
          description: 'tap submit button (pump half)',
          arrangeBeforeActions: (arrange) {
            when(
              () => arrange.mocks.authRepository.forgotPassword(
                email: any(named: 'email'),
              ),
            ).thenAnswer((invocation) async {
              await Future<void>.delayed(const Duration(seconds: 500));
              return;
            });
          },
          actions: (actions) async {
            await actions.userAction
                .tap(find.byType(ForgotPasswordC_ResetPasswordButton));
            await actions.testerAction.pump(const Duration(milliseconds: 250));
          },
          expectations: (expectations) {
            expectations.expect(
              find.byType(LoadingIndicator),
              findsOneWidget,
              reason: 'Should see a loading indicator',
            );
            expectations.expect(
              find.byType(ForgotPasswordConfirmation_Page),
              findsNothing,
              reason:
                  'Should not be on the ForgotPasswordConfirmation page yet',
            );
          },
          expectedEvents: [
            ForgotPasswordEvent_ForgotPassword,
          ],
        );

        await tester.screenshot(
          description: 'tap submit button (pump rest)',
          actions: (actions) async {
            await actions.testerAction.pumpAndSettle();
          },
          expectations: (expectations) {
            expectations.expect(
              find.byType(ForgotPasswordConfirmation_Page),
              findsOneWidget,
              reason: 'Should be on the ForgotPasswordConfirmation page',
            );
          },
          expectedEvents: [
            'Page: ForgotPasswordConfirmation',
          ],
        );
      },
    );

    flowTest(
      'HP1.B',
      config: createFlowConfig(
        hasAccessToken: false,
        deepLinkOverride: '/deep/resetPassword',
      ),
      descriptions: [
        ...baseDescriptions,
        happyPathDescription,
        FTDescription(
          descriptionType: 'PATH',
          shortDescription: 'path_b',
          description:
              '''The forgot password flow is in two parts, this is the second part, part B''',
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
          shortDescription: 'resend_email',
          description:
              '''If you don't receive the password reset email, you should be able to request the email again.''',
        ),
      ],
      test: (tester) async {
        await tester.setUp(
          arrangeBeforePumpApp: arrangeBeforeWarpToForgotPasswordConfirmation,
          warp: warpToForgotPasswordConfirmation,
        );

        await tester.screenshot(
          description: 'initial state',
          expectations: (expectations) {
            expectations.expect(
              find.byType(ForgotPasswordConfirmation_Page),
              findsOneWidget,
              reason: 'Should be on the ForgotPasswordConfirmation page',
            );
          },
        );

        await tester.screenshot(
          description: 'tap resend email',
          actions: (actions) async {
            await actions.userAction.tap(
              find.byType(ForgotPasswordConfirmationC_ResendEmailButton),
            );
            await actions.testerAction.pumpAndSettle();
          },
          expectations: (expectations) {
            expectations.expect(
              find.text('Email resent.'),
              findsOneWidget,
              reason:
                  '''Should see snackbar letting user know that email was resent.''',
            );
          },
          expectedEvents: [
            ForgotPasswordEvent_ResendForgotPassword,
          ],
        );
      },
    );
  });

  group(
    'Sad Path',
    () {
      final sadPathDescription = FTDescription(
        descriptionType: 'PATH',
        shortDescription: 'sad_path',
        description: '''Sad Path: Forgot password flow is not successful''',
      );

      flowTest(
        'SP1.A',
        config: createFlowConfig(
          hasAccessToken: false,
        ),
        descriptions: [
          ...baseDescriptions,
          sadPathDescription,
          FTDescription(
            descriptionType: 'AC',
            shortDescription: 'path_a_email_invalid',
            description:
                '''If you attempt to reset password, but the email is invalid, should see invalid error''',
          ),
        ],
        test: (tester) async {
          await tester.setUp(
            arrangeBeforePumpApp: arrangeBeforeWarpToForgotPassword,
            warp: warpToForgotPassword,
          );

          await tester.screenshot(
            description: 'initial state',
            expectations: (expectations) {
              expectations.expect(
                find.byType(ForgotPassword_Page),
                findsOneWidget,
                reason: 'Should be on the ForgotPassword page',
              );
            },
          );

          await tester.screenshot(
            description: 'enter email address',
            actions: (actions) async {
              await actions.userAction.enterText(
                find.byType(ForgotPasswordC_EmailTextField),
                'bad email',
              );
              await actions.testerAction.pumpAndSettle();
            },
          );

          await tester.screenshot(
            description: 'tap submit button',
            actions: (actions) async {
              await actions.userAction
                  .tap(find.byType(ForgotPasswordC_ResetPasswordButton));
              await actions.testerAction.pumpAndSettle();
            },
            expectations: (expectations) {
              expectations.expect(
                find.text('Please enter a valid email address.'),
                findsOneWidget,
                reason: 'Should see email invalid error',
              );
            },
            expectedEvents: [],
          );
        },
      );

      flowTest(
        'SP1.B',
        config: createFlowConfig(
          hasAccessToken: false,
          deepLinkOverride: '/deep/resetPassword',
        ),
        descriptions: [
          ...baseDescriptions,
          sadPathDescription,
          FTDescription(
            descriptionType: 'PATH',
            shortDescription: 'path_b_error',
            description:
                '''The forgot password flow is in two parts, this is the second part, part B, and the deep link can fail''',
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
              ).thenThrow(Exception('BOOM'));
            },
          );

          await tester.screenshot(
            description: 'initial state',
            actions: (actions) async {
              await actions.testerAction.pumpAndSettle();
            },
            expectations: (expectations) {
              expectations.expect(
                find.byType(SignIn_Page),
                findsOneWidget,
                reason: 'Should be on SignIn page',
              );
            },
            expectedEvents: [
              AuthEvent_SetSessionFromDeepLink,
              'Page: SignIn',
            ],
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
            shortDescription: 'resend_email_error',
            description:
                '''If you don't receive the password reset email, you should be able to request the email again, but the request can fail.''',
          ),
        ],
        test: (tester) async {
          await tester.setUp(
            arrangeBeforePumpApp: arrangeBeforeWarpToForgotPasswordConfirmation,
            warp: warpToForgotPasswordConfirmation,
          );

          await tester.screenshot(
            description: 'initial state',
            expectations: (expectations) {
              expectations.expect(
                find.byType(ForgotPasswordConfirmation_Page),
                findsOneWidget,
                reason: 'Should be on the ForgotPasswordConfirmation page',
              );
            },
          );

          await tester.screenshot(
            description: 'tap resend email',
            arrangeBeforeActions: (arrange) {
              when(
                () => arrange.mocks.authRepository.forgotPassword(
                  email: any(named: 'email'),
                ),
              ).thenThrow(Exception('BOOM'));
            },
            actions: (actions) async {
              await actions.userAction.tap(
                find.byType(ForgotPasswordConfirmationC_ResendEmailButton),
              );
              await actions.testerAction.pumpAndSettle();
            },
            expectations: (expectations) {
              expectations.expect(
                find.text('Could not resend email.'),
                findsOneWidget,
                reason:
                    '''Should see snackbar letting user know that email was not able to be resent.''',
              );
            },
            expectedEvents: [
              ForgotPasswordEvent_ResendForgotPassword,
            ],
          );
        },
      );
    },
  );
}
