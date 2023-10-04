import 'package:flow_test/flow_test.dart';
import 'package:flutter_test/flutter_test.dart' hide expect;

import 'package:mocktail/mocktail.dart';
import 'package:row_level_security/blocs/count/event.dart';
import 'package:row_level_security/pages/authenticated/home/page.dart';
import 'package:row_level_security/pages/authenticated/home/widgets/connector/decrement_button.dart';
import 'package:row_level_security/pages/authenticated/home/widgets/connector/increment_button.dart';

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
      shortDescription: 'counter',
      description:
          '''As a user, I should be able to read and change the count in the counter.''',
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
        shortDescription: 'update_count_success',
        description: '''Should be able update the count successfully.''',
      ),
    ],
    test: (tester) async {
      await tester.setUp(
        arrangeBeforePumpApp: arrangeBeforeWarpToHome,
      );

      await tester.screenshot(
        description: 'initial state',
        expectations: (expectations) {
          expectations.expect(
            find.byType(Home_Page),
            findsOneWidget,
            reason: 'Should be on the Home page',
          );
          expectations.expect(
            find.text('0'),
            findsOneWidget,
            reason: 'The initial count should be 0',
          );
        },
        expectedEvents: [
          'Page: Home',
          CountEvent_Initialize,
        ],
      );

      await tester.screenshot(
        description: 'increment count',
        arrangeBeforeActions: (arrange) {
          when(
            () => arrange.mocks.countRepository
                .updateCount(newCount: any(named: 'newCount')),
          ).thenAnswer(
            (invocation) async =>
                invocation.namedArguments[const Symbol('newCount')] as int,
          );
        },
        actions: (actions) async {
          await actions.userAction.tap(find.byType(HomeC_IncrementButton));
          await actions.testerAction.pumpAndSettle();
        },
        expectations: (expectations) {
          expectations.expect(
            find.text('1'),
            findsOneWidget,
            reason: 'The updated count should be 1',
          );
        },
        expectedEvents: [
          CountEvent_Increment,
        ],
      );

      await tester.screenshot(
        description: 'decrement count',
        arrangeBeforeActions: (arrange) {
          when(
            () => arrange.mocks.countRepository
                .updateCount(newCount: any(named: 'newCount')),
          ).thenAnswer(
            (invocation) async =>
                invocation.namedArguments[const Symbol('newCount')] as int,
          );
        },
        actions: (actions) async {
          await actions.userAction.tap(find.byType(HomeC_DecrementButton));
          await actions.testerAction.pumpAndSettle();
          await actions.userAction.tap(find.byType(HomeC_DecrementButton));
          await actions.testerAction.pumpAndSettle();
        },
        expectations: (expectations) {
          expectations.expect(
            find.text('-1'),
            findsOneWidget,
            reason: 'The updated count should be 11',
          );
        },
        expectedEvents: [
          CountEvent_Decrement,
          CountEvent_Decrement,
        ],
      );
    },
  );

  flowTest(
    'AC2',
    config: createFlowConfig(
      hasAccessToken: true,
    ),
    descriptions: [
      ...baseDescriptions,
      FTDescription(
        descriptionType: 'AC',
        shortDescription: 'update_count_failed',
        description:
            '''If updating the count fails, don't change the count. Note: in the future, we may want to update this requirement to give feedback to the user that the update failed.''',
      ),
    ],
    test: (tester) async {
      await tester.setUp(
        arrangeBeforePumpApp: arrangeBeforeWarpToHome,
      );

      await tester.screenshot(
        description: 'initial state',
        expectations: (expectations) {
          expectations.expect(
            find.byType(Home_Page),
            findsOneWidget,
            reason: 'Should be on the Home page',
          );
          expectations.expect(
            find.text('0'),
            findsOneWidget,
            reason: 'The initial count should be 0',
          );
        },
        expectedEvents: [
          'Page: Home',
          CountEvent_Initialize,
        ],
      );

      await tester.screenshot(
        description: 'increment count',
        arrangeBeforeActions: (arrange) {
          when(
            () => arrange.mocks.countRepository
                .updateCount(newCount: any(named: 'newCount')),
          ).thenThrow(Exception('BOOM'));
        },
        actions: (actions) async {
          await actions.userAction.tap(find.byType(HomeC_IncrementButton));
          await actions.testerAction.pumpAndSettle();
        },
        expectations: (expectations) {
          expectations.expect(
            find.text('0'),
            findsOneWidget,
            reason: 'Updating the count failed, so the count should stay 0',
          );
        },
        expectedEvents: [
          CountEvent_Increment,
        ],
      );

      await tester.screenshot(
        description: 'decrement count',
        arrangeBeforeActions: (arrange) {
          when(
            () => arrange.mocks.countRepository
                .updateCount(newCount: any(named: 'newCount')),
          ).thenThrow(Exception('BOOM'));
        },
        actions: (actions) async {
          await actions.userAction.tap(find.byType(HomeC_DecrementButton));
          await actions.testerAction.pumpAndSettle();
        },
        expectations: (expectations) {
          expectations.expect(
            find.text('0'),
            findsOneWidget,
            reason: 'Updating the count failed, so the count should stay 0',
          );
        },
        expectedEvents: [
          CountEvent_Decrement,
        ],
      );
    },
  );
}
