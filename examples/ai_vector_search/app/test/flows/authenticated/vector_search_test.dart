import 'package:ai_vector_search/blocs/search/event.dart';
import 'package:ai_vector_search/pages/authenticated/home/page.dart';
import 'package:ai_vector_search/pages/authenticated/home/widgets/connector/vector_search.dart';
import 'package:flow_test/flow_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart' hide expect;
import 'package:mocktail/mocktail.dart';

import '../../util/util.dart';
import '../../util/warp/to_home.dart';

// TODO: once it is handled in code, add test for sad path

void main() {
  final baseDescriptions = [
    FTDescription(
      descriptionType: 'EPIC',
      shortDescription: 'authenticated',
      description:
          '''As a user, I need to be able to interact with the appication when I am unauthenticated.''',
    ),
    FTDescription(
      descriptionType: 'STORY',
      shortDescription: 'vector_search',
      description:
          '''As a user, I should be able to ask questions against Deno's documentation using a vector search.''',
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
          descriptionType: 'AC',
          shortDescription: 'happy_path',
          description: '''Happy Path: vector search is successful''',
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
          },
          expectedEvents: [
            'Page: Home',
          ],
        );

        await tester.screenshot(
          description: 'enter question in text field',
          actions: (actions) async {
            await actions.userAction.enterText(
              find.descendant(
                of: find.byType(HomeC_VectorSearch),
                matching: find.byType(TextFormField),
              ),
              'What is Deno?',
            );
            await actions.testerAction.pumpAndSettle();
          },
          expectations: (expectations) {
            expectations.expect(
              find.text('What is Deno?'),
              findsOneWidget,
              reason: 'Should see what you entered in the text field',
            );
          },
        );

        await tester.screenshot(
          description: 'Tap Query Deno Documentation',
          arrangeBeforeActions: (arrange) {
            arrange.extras['deno_answer'] =
                '''Deno is a secure runtime for JavaScript and TypeScript that is based on the V8 JavaScript engine and the Rust programming language. It is designed to be a modern, secure, and productive software development environment. Deno provides a set of core APIs for creating web servers, making network requests, and interacting with the file system, as well as a set of third-party modules for additional functionality.''';

            when(
              () => arrange.mocks.searchRepository.vectorSearch(
                query: any(named: 'query'),
              ),
            ).thenAnswer(
              (invocation) async => arrange.extras['deno_answer'] as String,
            );
          },
          actions: (actions) async {
            await actions.userAction.tap(find.text('Query Deno Documentation'));
            await actions.testerAction.pumpAndSettle();
          },
          expectations: (expectations) {
            expectations.expect(
              find.text(
                expectations.extras['deno_answer'] as String,
                findRichText: true,
              ),
              findsOneWidget,
              reason: 'Should see the Deno answer',
            );
          },
          expectedEvents: [
            SearchEvent_VectorSearch,
          ],
        );
      },
    );
  });
}
