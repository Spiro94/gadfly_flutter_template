import 'package:flutter_test/flutter_test.dart';
import 'package:gadfly_flutter_template/blocs/auth/event.dart';
import 'package:gadfly_flutter_template/pages/authenticated/home/page.dart';
import 'package:gadfly_flutter_template/pages/authenticated/home/widgets/connector/sign_out_button.dart';
import 'package:gadfly_flutter_template/pages/unauthenticated/sign_in/page.dart';
import 'package:mocktail/mocktail.dart';

import '../../util/fake/fake_now_effect.dart';
import '../../util/test_flow.dart';

void main() {
  testFlow(
    'As a user, I should be able to sign out',
    setup: (tester, mocks, pumpApp) async {
      when(() => mocks.nowEffectProvider.getEffect())
          .thenReturn(FakeNowEffect());

      await mocks.sharedPreferencesEffectProvider.setMockIntialValue({
        'authToken': 'fakeToken',
      });
      await pumpApp();
    },
    test: (testAction) async {
      await testAction(
        'initial state',
        assertion: () {
          expect(
            find.byType(Home_Page),
            findsOneWidget,
            reason: 'Should be on the Home page if already have an authToken',
          );
        },
      );

      await testAction(
        'tap `Sign Out` button',
        act: (tester) async {
          await tester.tap(find.byType(HomeC_SignOutButton));
          await tester.pumpAndSettle();
        },
        assertion: () {
          expect(
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
