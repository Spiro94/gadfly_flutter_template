import 'package:flow_test/flow_test.dart';

import '../../util/flow_config.dart';
import '../../util/warp/to_home.dart';
import 'epic_description.dart';

void main() {
  final baseDescriptions = [
    authenticatedEpicDescription,
    FTDescription(
      descriptionType: 'STORY',
      directoryName: 'route_guard',
      description:
          '''As a user, if I go directly to a URL, the route guards should handle whether or not I have access.''',
      atScreenshotsLevel: true,
    ),
  ];

  flowTest(
    'deep_link_home_with_access_token',
    config: createFlowConfig(
      hasAccessToken: true,
      deepLinkOverride: '/',
    ),
    descriptions: [
      ...baseDescriptions,
      FTDescription(
        descriptionType: 'AC',
        directoryName: 'deep_link_home_with_access_token',
        description: '''Deep link to home with access token''',
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
    },
  );

  flowTest(
    'deep_link_home_without_access_token',
    config: createFlowConfig(
      hasAccessToken: false,
      deepLinkOverride: '/',
    ),
    descriptions: [
      ...baseDescriptions,
      FTDescription(
        descriptionType: 'AC',
        directoryName: 'deep_link_home_without_access_token',
        description: '''Deep link to home without access token''',
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
          'INFO: [authenticated_guard] not authenticated',
          'Page: SignIn',
        ],
      );
    },
  );
}
