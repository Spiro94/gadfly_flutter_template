import 'package:flow_test/flow_test.dart';
import 'package:flutter_test/flutter_test.dart' hide expect;
import 'package:google_auth/blocs/auth/event.dart';
import 'package:google_auth/blocs/sign_in/event.dart';
import 'package:google_auth/pages/authenticated/home/page.dart';
import 'package:google_auth/pages/unauthenticated/sign_in/page.dart';
import 'package:google_auth/pages/unauthenticated/sign_in/widgets/connector/google_auth_button.dart';

import 'package:mocktail/mocktail.dart';

import '../../util/fake/auth_change_effect.dart';
import '../../util/util.dart';
import '../../util/warp/to_home.dart';

// TODO: write sad path test for google authentication flow

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
      shortDescription: 'google_auth',
      description:
          '''As a user, I should be able to sign in by using my google account.''',
      atScreenshotsLevel: true,
    ),
  ];

  group('Happy Path', () {
    final happyPathDescription = FTDescription(
      descriptionType: 'PATH',
      shortDescription: 'happy_path',
      description: '''Happy Path: Google auth flow is successful''',
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
              '''The google auth flow is in two parts, this is the first part, part A''',
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
          description: 'tap sign in with google button',
          arrangeBeforeActions: (arrange) {
            when(() => arrange.mocks.authRepository.signInWithGoogle())
                .thenAnswer((invocation) async => true);
          },
          actions: (actions) async {
            await actions.userAction.tap(
              find.byType(SignInC_GoogleAuthButton),
            );
            await actions.testerAction.pumpAndSettle();
          },
          expectedEvents: [
            SignInEvent_SignInWithGoogle,
          ],
        );
      },
    );

    flowTest(
      'HP1.B',
      config: createFlowConfig(
        hasAccessToken: false,
        deepLinkOverride: '/deep/googleAuth',
      ),
      descriptions: [
        ...baseDescriptions,
        happyPathDescription,
        FTDescription(
          descriptionType: 'PATH',
          shortDescription: 'path_b',
          description:
              '''The google auth flow is in two parts, this is the second part, part B''',
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
              find.byType(Home_Page),
              findsOneWidget,
              reason: 'Should be on Home page',
            );
          },
          expectedEvents: [
            AuthEvent_SetSessionFromDeepLink,
            'Page: Home',
          ],
        );
      },
    );
  });
}
