import 'package:flow_test/flow_test.dart';
import 'package:flutter_test/flutter_test.dart' hide expect;
import 'package:mocktail/mocktail.dart';
import 'package:realtime_custom_claims/blocs/custom_claims/event.dart';
import 'package:realtime_custom_claims/pages/authenticated/home/page.dart';
import '../../util/util.dart';
import '../../util/warp/to_home.dart';

void main() {
  final baseDescriptions = [
    FTDescription(
      descriptionType: 'EPIC',
      shortDescription: 'authenticated',
      description:
          '''As a user, I need to be able to interact with the appication when I am authenticated.''',
    ),
    FTDescription(
      descriptionType: 'STORY',
      shortDescription: 'custom_claims',
      description:
          '''As a user, I should be able to see my custom claims in real-time.''',
      atScreenshotsLevel: true,
    ),
  ];

  flowTest(
    'AC1',
    config: createFlowConfig(
      hasAccessToken: true,
    ),
    descriptions: [
      ...baseDescriptions,
      FTDescription(
        descriptionType: 'AC',
        shortDescription: 'get_my_claims',
        description: '''Getting my claims is successful''',
      ),
    ],
    test: (tester) async {
      await tester.setUp(arrangeBeforePumpApp: arrangeBeforeWarpToHome);

      await tester.screenshot(
        description: 'initial state',
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
          'Page: Home',
          CustomClaimsEvent_Initialize,
        ],
      );

      await tester.screenshot(
        description: 'get realtime update',
        arrangeBeforeActions: (arrange) {
          when(() => arrange.mocks.customClaimsRepository.refreshAuthSession())
              .thenAnswer((invocation) async {});

          when(() => arrange.mocks.customClaimsRepository.getMyClaims())
              .thenAnswer((invocation) async => {'app_role': 'ADMIN'});

          arrange
              .mocks.customClaimsRepository.customClaimUpdatesStreamController
              .add([
            {
              'updated_at': DateTime(1970, 1, 1).toIso8601String(),
            },
          ]);
        },
        actions: (actions) async {
          await actions.testerAction.pumpAndSettle();
        },
        expectations: (expectations) {
          expectations.expect(
            find.text(
              'App Role: ADMIN',
            ),
            findsOneWidget,
            reason: 'Should see app role of ADMIN',
          );
        },
        expectedEvents: [
          CustomClaimsEvent_Refresh,
        ],
      );
    },
  );
}
