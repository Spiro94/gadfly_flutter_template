import 'package:flow_test/flow_test.dart';
import 'package:flutter_test/flutter_test.dart' hide expect;
import 'package:gadfly_flutter_template/blocs/auth/event.dart';
import 'package:gadfly_flutter_template/routes/authenticated/home/widgets/sign_out_button.dart';
import 'package:mocktail/mocktail.dart';

import '../../util/flow_config.dart';
import '../../util/warp/to_home.dart';
import 'epic_description.dart';

void main() {
  final baseDescriptions = [
    authenticatedEpicDescription,
    FTDescription(
      descriptionType: 'STORY',
      directoryName: 'sign_out',
      description:
          '''As a user, I should be able to sign out when I am signed in.''',
      atScreenshotsLevel: true,
    ),
  ];

  flowTest(
    'success',
    config: createFlowConfig(
      hasAccessToken: true,
    ),
    descriptions: [
      ...baseDescriptions,
      FTDescription(
        descriptionType: 'AC',
        directoryName: 'success',
        description: '''Sign out successful''',
      ),
    ],
    test: (tester) async {
      await tester.setUp(
        arrangeBeforePumpApp: (arrange) async {
          await arrangeBeforeWarpToHome(arrange);
        },
      );

      await tester.screenshot(
        description: 'initial state',
        actions: (actions) async {
          await actions.testerAction.pumpAndSettle();
        },
        expectations: (expectations) {},
        expectedEvents: [
          'INFO: [router] deeplink: /',
          'Page: Home',
        ],
      );

      await tester.screenshot(
        description: 'tap sign out button',
        arrangeBeforeActions: (arrange) {
          when(
            () => arrange.mocks.authRepository.signOut(),
          ).thenAnswer((invocation) async {
            return;
          });
          when(
            () => arrange.mocks.sharedPreferencesEffect.clear(),
          ).thenAnswer((invocation) async {
            return true;
          });
        },
        actions: (actions) async {
          await actions.userAction.tap(find.byType(Home_SignOutButton));
          await actions.testerAction.pumpAndSettle();
        },
        expectedEvents: [
          AuthEvent_SignOut,
          'Page: SignIn',
        ],
      );
    },
  );

  group('error', () {
    final errorDescription = FTDescription(
      descriptionType: 'AC',
      directoryName: 'error',
      description: '''Signing out is not successful''',
    );

    flowTest(
      'repository',
      config: createFlowConfig(
        hasAccessToken: true,
      ),
      descriptions: [
        ...baseDescriptions,
        errorDescription,
        FTDescription(
          descriptionType: 'STATUS',
          directoryName: 'repository',
          description: '''Error in repository method''',
        ),
      ],
      test: (tester) async {
        await tester.setUp(
          arrangeBeforePumpApp: (arrange) async {
            await arrangeBeforeWarpToHome(arrange);
          },
        );

        await tester.screenshot(
          description: 'initial state',
          actions: (actions) async {
            await actions.testerAction.pumpAndSettle();
          },
          expectations: (expectations) {},
          expectedEvents: [
            'INFO: [router] deeplink: /',
            'Page: Home',
          ],
        );

        await tester.screenshot(
          description: 'tap sign out button',
          arrangeBeforeActions: (arrange) {
            when(
              () => arrange.mocks.authRepository.signOut(),
            ).thenThrow(Exception('BOOM'));

            when(() => arrange.mocks.sharedPreferencesEffect.clear())
                .thenAnswer((invocation) async => true);
          },
          actions: (actions) async {
            await actions.userAction.tap(find.byType(Home_SignOutButton));
            await actions.testerAction.pumpAndSettle();
          },
          expectedEvents: [
            AuthEvent_SignOut,
            'WARNING: [auth_bloc] sign out error',
            'Page: SignIn',
          ],
        );
      },
    );

    flowTest(
      'shared_preferences',
      config: createFlowConfig(
        hasAccessToken: true,
      ),
      descriptions: [
        ...baseDescriptions,
        errorDescription,
        FTDescription(
          descriptionType: 'STATUS',
          directoryName: 'shared_preferences',
          description: '''Could not clear shared preferences''',
        ),
      ],
      test: (tester) async {
        await tester.setUp(
          arrangeBeforePumpApp: (arrange) async {
            await arrangeBeforeWarpToHome(arrange);
          },
        );

        await tester.screenshot(
          description: 'initial state',
          actions: (actions) async {
            await actions.testerAction.pumpAndSettle();
          },
          expectations: (expectations) {},
          expectedEvents: [
            'INFO: [router] deeplink: /',
            'Page: Home',
          ],
        );

        await tester.screenshot(
          description: 'tap sign out button',
          arrangeBeforeActions: (arrange) {
            when(
              () => arrange.mocks.authRepository.signOut(),
            ).thenAnswer((invocation) async {
              return;
            });
            when(
              () => arrange.mocks.sharedPreferencesEffect.clear(),
            ).thenThrow(Exception('BOOM'));
          },
          actions: (actions) async {
            await actions.userAction.tap(find.byType(Home_SignOutButton));
            await actions.testerAction.pumpAndSettle();
          },
          expectedEvents: [
            AuthEvent_SignOut,
            'WARNING: [auth_bloc] could not clear shared preferences',
            'Page: SignIn',
          ],
        );
      },
    );
  });
}
