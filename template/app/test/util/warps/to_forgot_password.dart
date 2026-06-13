import 'package:flow_test/flow_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gadfly_flutter_template/inside/routes/unauthenticated/sign_in/widgets/link_forgot_password.dart';

import '../mocks/mocked_app.dart';

Future<void> arrangeBeforeWarpToForgotPassword(
  FTArrange<MocksContainer> arrange,
) async {}

Future<void> warpToForgotPassword(FTWarp<MocksContainer> warp) async {
  await warp.testerAction.pumpAndSettle();

  await warp.userAction.tap(
    find.descendant(
      of: find.byType(SignIn_Link_ForgotPassword),
      matching: find.text('Forgot password?'),
      matchRoot: true,
    ),
  );

  await warp.testerAction.pumpAndSettle();
}
