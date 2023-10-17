import 'package:ai_image/blocs/image_generation/event.dart';
import 'package:ai_image/pages/authenticated/home/page.dart';
import 'package:flow_test/flow_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart' hide expect;
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';

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
      shortDescription: 'generate_avatar',
      description:
          '''As a user, I should be able to generate an avatar image from text using AI''',
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
          description: '''Happy Path: Creating image was successful''',
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
          ],
        );

        await tester.screenshot(
          description: 'add text to generate avatar',
          actions: (actions) async {
            await actions.userAction
                .enterText(find.byType(TextField), 'A basketball in the woods');
            await actions.testerAction.pumpAndSettle();
          },
          expectations: (expectations) {
            expectations.expect(
              find.text('A basketball in the woods'),
              findsOneWidget,
              reason: '''Should see the text that was entered''',
            );
          },
        );

        await tester.screenshot(
          description: 'tap submit to generate avatar image',
          arrangeBeforeActions: (arrange) {
            when(
              () => arrange.mocks.imageGenerationRepository
                  .generateAvatar(input: any(named: 'input')),
            ).thenAnswer((invocation) async {});

            when(
              () => arrange.mocks.imageGenerationRepository.getAvatarUrl(),
            ).thenAnswer((invocation) async => 'example.com');
          },
          actions: (actions) async {
            // Note: in tests, we can't execute http request, so we need to mock
            // them
            await mockNetworkImages(() async {
              await actions.userAction.tap(find.text('Submit'));
              await actions.testerAction.pumpAndSettle();
            });
          },
          expectations: (expectations) {},
          expectedEvents: [
            ImageGenerationEvent_CreateAvatarImage,
          ],
        );
      },
    );
  });

  group('Sad Path', () {
    flowTest(
      'SP1',
      config: createFlowConfig(
        hasAccessToken: true,
      ),
      descriptions: [
        ...baseDescriptions,
        FTDescription(
          descriptionType: 'PATH',
          shortDescription: 'sad_path',
          description: '''Sad Path: Creating image failed''',
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
          ],
        );

        await tester.screenshot(
          description: 'add text to generate avatar',
          actions: (actions) async {
            await actions.userAction
                .enterText(find.byType(TextField), 'A basketball in the woods');
            await actions.testerAction.pumpAndSettle();
          },
          expectations: (expectations) {
            expectations.expect(
              find.text('A basketball in the woods'),
              findsOneWidget,
              reason: '''Should see the text that was entered''',
            );
          },
        );

        await tester.screenshot(
          description: 'tap submit to generate avatar image',
          arrangeBeforeActions: (arrange) {
            when(
              () => arrange.mocks.imageGenerationRepository
                  .generateAvatar(input: any(named: 'input')),
            ).thenThrow(Exception('BOOM'));
          },
          actions: (actions) async {
            await mockNetworkImages(() async {
              await actions.userAction.tap(find.text('Submit'));
              await actions.testerAction.pumpAndSettle();
            });
          },
          expectations: (expectations) {},
          expectedEvents: [
            ImageGenerationEvent_CreateAvatarImage,
            'WARNING: [image_generation_bloc] Exception: BOOM',
          ],
        );
      },
    );
  });
}
