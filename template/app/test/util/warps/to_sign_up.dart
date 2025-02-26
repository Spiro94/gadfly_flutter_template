import 'package:flow_test/flow_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gadfly_flutter_template/inside/routes/unauthenitcated/sign_in/widgets/link_sign_up.dart';

import '../mocks/mocked_app.dart';

Future<void> arrangeBeforeWarpToSignUp(
  FTArrange<MocksContainer> arrange,
) async {}

Future<void> warpToSignUp(
  FTWarp<MocksContainer> warp,
) async {
  await warp.testerAction.pumpAndSettle();

  await warp.userAction.tap(
    find.descendant(
      of: find.byType(SignIn_Link_SignUp),
      matching: find.text('Sign Up'),
      matchRoot: true,
    ),
  );

  await warp.testerAction.pumpAndSettle();
}
