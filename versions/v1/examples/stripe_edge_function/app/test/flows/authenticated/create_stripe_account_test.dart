import 'package:flow_test/flow_test.dart';
import 'package:flutter_test/flutter_test.dart' hide expect;
import 'package:mocktail/mocktail.dart';
import 'package:stripe_edge_function/blocs/payments/event.dart';
import 'package:stripe_edge_function/pages/authenticated/home/page.dart';
import 'package:stripe_edge_function/pages/authenticated/home/widgets/connector/create_stripe_account_button.dart';

import '../../util/util.dart';

import '../../util/warp/to_home.dart';

// TODO: the sad path is not handled, but when it is, write a test for it

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
      shortDescription: 'create_stripe_account',
      description:
          '''As a user, I should be able to create a connected stripe account, so that I can eventually pay for this service.''',
      atScreenshotsLevel: true,
    ),
  ];

  group('Happy Path', () {
    flowTest(
      'HP1',
      config: createFlowConfig(
        hasAccessToken: true,
      ),
      descriptions: [
        ...baseDescriptions,
        FTDescription(
          descriptionType: 'PATH',
          shortDescription: 'happy_path',
          description: '''Happy Path: Creating stripe account is successful''',
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
          expectations: (expectations) {
            expectations.expect(
              find.byType(Home_Page),
              findsOneWidget,
              reason: 'Should be on Home page',
            );
          },
          expectedEvents: [
            'Page: Home',
            PaymentsEvent_Initialize,
          ],
        );

        await tester.screenshot(
          description: 'tap button to create stripe account',
          arrangeBeforeActions: (arrange) {
            when(() => arrange.mocks.paymentsRepository.createStripeAccount())
                .thenAnswer((invocation) async => 'fakeAccountId');
          },
          actions: (actions) async {
            await actions.userAction
                .tap(find.byType(HomeC_CreateStripeAccountButton));
            await actions.testerAction.pumpAndSettle();
          },
          expectations: (expectations) {
            expectations.expect(
              find.text('Stripe ID: fakeAccountId'),
              findsOneWidget,
              reason:
                  '''After creating stripe account, the stripe id should be displayed to the user''',
            );
          },
          expectedEvents: [
            PaymentsEvent_CreatePaymentAccount,
          ],
        );
      },
    );
  });
}
