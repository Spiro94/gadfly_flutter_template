import 'package:flow_test/flow_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart' hide expect;
import 'package:gadfly_flutter_template/blocs/auth/event.dart';
import 'package:gadfly_flutter_template/blocs/forgot_password/event.dart';
import 'package:gadfly_flutter_template/blocs/recordings/event.dart';
import 'package:gadfly_flutter_template/pages/authenticated/reset_password/page.dart';
import 'package:gadfly_flutter_template/pages/unauthenticated/forgot_flow/forgot_password/page.dart';
import 'package:gadfly_flutter_template/pages/unauthenticated/forgot_flow/forgot_password/widgets/connector/app_bar.dart';
import 'package:gadfly_flutter_template/pages/unauthenticated/forgot_flow/forgot_password/widgets/connector/email_text_field.dart';
import 'package:gadfly_flutter_template/pages/unauthenticated/forgot_flow/forgot_password/widgets/connector/reset_password_button.dart';
import 'package:gadfly_flutter_template/pages/unauthenticated/forgot_flow/forgot_password_confirmation/page.dart';
import 'package:gadfly_flutter_template/pages/unauthenticated/forgot_flow/forgot_password_confirmation/widgets/connector/resend_email_button.dart';
import 'package:gadfly_flutter_template/pages/unauthenticated/sign_in/page.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:mocktail/mocktail.dart';

import '../../util/flow_config.dart';
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

  group('path_a', () {
    final pathADescription = FTDescription(
      descriptionType: 'PATH',
      shortDescription: 'path_a',
      description:
          '''The forgot password flow is in two parts, this is the first part, part A''',
    );
    group('success', () {
      final successDescriptions = [
        pathADescription,
        FTDescription(
          descriptionType: 'AC',
          shortDescription: 'success',
          description: '''Forgot password flow is successful''',
        ),
      ];

      flowTest(
        'tap submit',
        config: createFlowConfig(
          hasAccessToken: false,
        ),
        descriptions: [
          ...baseDescriptions,
          ...successDescriptions,
          FTDescription(
            descriptionType: 'SUBMIT',
            shortDescription: 'by_tap',
            description: '''tap submit''',
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
              await actions.testerAction
                  .pump(const Duration(milliseconds: 250));
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
        'press enter',
        config: createFlowConfig(
          hasAccessToken: false,
        ),
        descriptions: [
          ...baseDescriptions,
          ...successDescriptions,
          FTDescription(
            descriptionType: 'SUBMIT',
            shortDescription: 'press_enter',
            description: 'press enter',
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
            description: 'press enter (pump half)',
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
              await actions.userAction.testTextInputReceiveNext();
              await actions.testerAction
                  .pump(const Duration(milliseconds: 250));
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
    });

    group(
      'error',
      () {
        final errorDescriptions = [
          pathADescription,
          FTDescription(
            descriptionType: 'AC',
            shortDescription: 'error',
            description: '''Forgot password flow is not successful''',
          ),
        ];

        flowTest(
          'email_invalid',
          config: createFlowConfig(
            hasAccessToken: false,
          ),
          descriptions: [
            ...baseDescriptions,
            ...errorDescriptions,
            FTDescription(
              descriptionType: 'STATUS',
              shortDescription: 'email_invalid',
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
          'http_error',
          config: createFlowConfig(
            hasAccessToken: false,
          ),
          descriptions: [
            ...baseDescriptions,
            ...errorDescriptions,
            FTDescription(
              descriptionType: 'STATUS',
              shortDescription: 'http_error',
              description:
                  '''If you attempt to reset password, but there is an http error, should see error snackbar.''',
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
              description: 'tap submit button',
              arrangeBeforeActions: (arrange) {
                when(
                  () => arrange.mocks.authRepository.forgotPassword(
                    email: any(named: 'email'),
                  ),
                ).thenThrow(Exception('BOOM'));
              },
              actions: (actions) async {
                await actions.userAction
                    .tap(find.byType(ForgotPasswordC_ResetPasswordButton));
                await actions.testerAction.pumpAndSettle();
              },
              expectations: (expectations) {
                expectations.expect(
                  find.byType(ForgotPassword_Page),
                  findsOneWidget,
                  reason: 'Should still be on forgot password page',
                );
                expectations.expect(
                  find.descendant(
                    of: find.byType(SnackBar),
                    matching: find.text('Could not reset password.'),
                  ),
                  findsOneWidget,
                  reason: 'Should still be on forgot password page',
                );
              },
              expectedEvents: [
                ForgotPasswordEvent_ForgotPassword,
              ],
            );
          },
        );
      },
    );
  });
  group('path_b', () {
    final pathBDescription = FTDescription(
      descriptionType: 'PATH',
      shortDescription: 'path_b',
      description:
          '''The forgot password flow is in two parts, this is the second part, part B''',
    );

    group('deep link', () {
      final deepLinkDescriptions = [
        pathBDescription,
        FTDescription(
          descriptionType: 'AC',
          shortDescription: 'deep_link',
          description: '''The app opens to a deep link.''',
        ),
      ];

      flowTest(
        'success',
        config: createFlowConfig(
          hasAccessToken: false,
          deepLinkOverride: '/deep/resetPassword',
        ),
        descriptions: [
          ...baseDescriptions,
          ...deepLinkDescriptions,
          FTDescription(
            descriptionType: 'STATUS',
            shortDescription: 'success',
            description: '''Forgot password flow is successful''',
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
              'INFO: [router] deeplink: /',
              AuthEvent_SetSessionFromDeepLink,
              'Page: Home',
              'Page: ResetPassword',
              RecordingsEvent_GetMyRecordings,
            ],
          );
        },
      );

      flowTest(
        'error',
        config: createFlowConfig(
          hasAccessToken: false,
          deepLinkOverride: '/deep/resetPassword',
        ),
        descriptions: [
          ...baseDescriptions,
          ...deepLinkDescriptions,
          FTDescription(
            descriptionType: 'STATUS',
            shortDescription: 'error',
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
              'INFO: [router] deeplink: /',
              AuthEvent_SetSessionFromDeepLink,
              'INFO: [router] not authenticated',
              'Page: SignIn',
            ],
          );
        },
      );
    });

    group('resend email', () {
      final resendEmailDescriptions = [
        pathBDescription,
        FTDescription(
          descriptionType: 'AC',
          shortDescription: 'resend_email',
          description:
              '''If you don't receive the password reset email, you should be able to request the email again.''',
        ),
      ];

      flowTest(
        'success',
        config: createFlowConfig(
          hasAccessToken: false,
        ),
        descriptions: [
          ...baseDescriptions,
          ...resendEmailDescriptions,
          FTDescription(
            descriptionType: 'STATUS',
            shortDescription: 'success',
            description: 'Is success',
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

      flowTest(
        'error',
        config: createFlowConfig(
          hasAccessToken: false,
        ),
        descriptions: [
          ...baseDescriptions,
          ...resendEmailDescriptions,
          FTDescription(
            descriptionType: 'STATUS',
            shortDescription: 'http_error',
            description: '''The http request can fail.''',
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
    });
  });

  group('navigation', () {
    final happyPathDescription = FTDescription(
      descriptionType: 'PATH',
      shortDescription: 'navigation',
      description: '''Navigation''',
    );

    flowTest(
      'navigate back',
      config: createFlowConfig(
        hasAccessToken: false,
      ),
      descriptions: [
        ...baseDescriptions,
        happyPathDescription,
        FTDescription(
          descriptionType: 'AC',
          shortDescription: 'navigate_back',
          description: 'Can navigate back.',
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
          description: 'tap back button',
          actions: (actions) async {
            await actions.userAction.tap(
              find.descendant(
                of: find.byType(ForgotPasswordC_AppBar),
                matching: find.byType(BackButton),
              ),
            );
            await actions.testerAction.pumpAndSettle();
          },
          expectations: (expectations) {
            expectations.expect(
              find.byType(SignIn_Page),
              findsOneWidget,
              reason: 'Should be on the SignIn page',
            );
          },
          expectedEvents: ['Page popped: SignIn'],
        );
      },
    );
  });
}
