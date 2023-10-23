import 'package:flow_test/flow_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart' hide expect;
import 'package:mocktail/mocktail.dart';
import 'package:realtime_chat/blocs/chat/event.dart';
import 'package:realtime_chat/pages/authenticated/home/page.dart';
import 'package:realtime_chat/pages/authenticated/home/widgets/connector/messages_container.dart';
import 'package:realtime_chat/pages/authenticated/home/widgets/connector/send_message_container.dart';
import '../../util/util.dart';
import '../../util/warp/to_home.dart';

// TODO: add test for when sending a message fails

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
      shortDescription: 'chat',
      description:
          '''As a user, I should be able to send and recieve chat messages in real-time.''',
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
        shortDescription: 'send_message',
        description: '''Send message is successful''',
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
          ChatEvent_Initialize,
        ],
      );

      await tester.screenshot(
        description: 'type message',
        actions: (actions) async {
          await actions.userAction
              .enterText(find.byType(TextFormField), 'hello world');
          await actions.testerAction.pumpAndSettle();
        },
        expectations: (expectations) {
          expectations.expect(
            find.descendant(
              of: find.byType(HomeC_SendMessageContainer),
              matching: find.text('hello world'),
            ),
            findsOneWidget,
            reason: 'Should see message in text field',
          );

          expectations.expect(
            find.descendant(
              of: find.byType(HomeC_MessagesContainer),
              matching: find.text('hello world'),
            ),
            findsNothing,
            reason: 'Should NOT see message in messages container',
          );
        },
      );

      await tester.screenshot(
        description: 'send message',
        arrangeBeforeActions: (arrange) {
          when(
            () => arrange.mocks.chatRepository
                .sendMessage(message: any(named: 'message')),
          ).thenAnswer((invocation) async {});
        },
        actions: (actions) async {
          await actions.userAction.tap(find.text('Send'));
          await actions.testerAction.pumpAndSettle();
        },
        arrangeAfterActions: (arrange) {
          arrange.mocks.chatRepository.messagesStreamController.add([
            {'message': 'hello world'},
          ]);
        },
        expectations: (expectations) {
          expectations.expect(
            find.descendant(
              of: find.byType(HomeC_SendMessageContainer),
              matching: find.text('hello world'),
            ),
            findsNothing,
            reason: 'Should NOT see message in text field',
          );

          expectations.expect(
            find.descendant(
              of: find.byType(HomeC_MessagesContainer),
              matching: find.text('hello world'),
            ),
            findsOneWidget,
            reason: 'Should see message in messages container',
          );
        },
        expectedEvents: [
          ChatEvent_SendMessage,
          ChatEvent_UpdateMessages,
        ],
      );
    },
  );
}
