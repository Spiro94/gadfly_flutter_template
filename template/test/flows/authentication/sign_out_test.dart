import 'package:flow_test/flow_test.dart';
import 'package:flutter_test/flutter_test.dart' hide expect;
import 'package:gadfly_flutter_template/blocs/auth/event.dart';
import 'package:gadfly_flutter_template/pages/authenticated/home/page.dart';
import 'package:gadfly_flutter_template/pages/authenticated/home/widgets/connector/sign_out_button.dart';
import 'package:gadfly_flutter_template/pages/unauthenticated/sign_in/page.dart';
import 'package:mocktail/mocktail.dart';

import '../../util/util.dart';

void main() {
  final baseDescriptions = [
    FTDescription(
      descriptionType: 'EPIC',
      shortDescription: 'authentication',
      description: '''As a user, I can be authenticated or unauthenticated.''',
    ),
    FTDescription(
      descriptionType: 'STORY',
      shortDescription: 'sign_out',
      description:
          '''As a user, I should be able to sign out of the application, so that I can become unauthenticated.''',
      atScreenshotsLevel: true,
    ),
  ];

  flowTest(
    'AC1',
    config: createFlowConfig(),
    descriptions: [
      ...baseDescriptions,
      FTDescription(
        descriptionType: 'AC',
        shortDescription: 'success',
        description: 'Signing out is a successful',
      ),
    ],
    test: (tester) async {
      await tester.setUp(
        arrangeBeforePumpApp: (arrange) async {
          when(arrange.mocks.nowEffectProvider.getEffect)
              .thenReturn(FakeNowEffect());

          await arrange.mocks.sharedPreferencesEffectProvider
              .setMockIntialValue({
            'authToken': 'fakeToken',
          });
        },
      );

      await tester.screenshot(
        description: 'initial state',
        expectations: (expectations) {
          expectations.expect(
            find.byType(Home_Page),
            findsOneWidget,
            reason: 'Should be on the Home page if already have an authToken',
          );
        },
        expectedEvents: ['Page: Home'],
      );

      await tester.screenshot(
        description: 'tap `Sign Out` button',
        actions: (actions) async {
          await actions.userAction.tap(find.byType(HomeC_SignOutButton));
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
          AuthEvent_SignOut,
          'Track: Sign Out',
          'Page: SignIn',
        ],
      );
    },
  );
}
