import 'package:flow_test/flow_test.dart';

import '../../util/flow_config.dart';
import '../../util/warp/to_home.dart';
import 'epic_description.dart';

void main() {
  final baseDescriptions = [
    unauthenticatedEpicDescription,
    FTDescription(
      descriptionType: 'STORY',
      directoryName: 'route_guard',
      description:
          '''As a user, if I go directly to a URL, the route guards should handle whether or not I have access.''',
      atScreenshotsLevel: true,
    ),
  ];

  flowTest(
    'deep_link_sign_in_without_access_token',
    config: createFlowConfig(
      hasAccessToken: false,
      deepLinkOverride: '/anon/signIn',
    ),
    descriptions: [
      ...baseDescriptions,
      FTDescription(
        descriptionType: 'AC',
        directoryName: 'deep_link_sign_in_without_access_token',
        description: '''Deep link to sign in without access token''',
      ),
    ],
    test: (tester) async {
      await tester.setUp();

      await tester.screenshot(
        description: 'initial state',
        actions: (actions) async {
          await actions.testerAction.pumpAndSettle();
        },
        expectations: (expectations) {},
        expectedEvents: [
          'INFO: [router] deeplink: /anon/signIn',
          'Page: SignIn',
        ],
      );
    },
  );

  flowTest(
    'deep_link_sign_in_with_access_token',
    config: createFlowConfig(
      hasAccessToken: true,
      deepLinkOverride: '/anon/signIn',
    ),
    descriptions: [
      ...baseDescriptions,
      FTDescription(
        descriptionType: 'AC',
        directoryName: 'deep_link_sign_in_with_access_token',
        description: '''Deep link to sign in with access token''',
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
          'INFO: [router] deeplink: /anon/signIn',
          'INFO: [unauthenticated_guard] already authenticated',
          'Page: Home',
        ],
      );
    },
  );
}
