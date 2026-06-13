import 'package:flow_test/flow_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gadfly_flutter_template/inside/routes/unauthenticated/forgot_password_flow/forgot_password/widgets/button_submit.dart';
import 'package:gadfly_flutter_template/inside/routes/unauthenticated/forgot_password_flow/forgot_password/widgets/input_email.dart';
import 'package:mocktail/mocktail.dart';

import '../mocks/mocked_app.dart';
import 'to_forgot_password.dart';

Future<void> arrangeBeforeWarpToResetPasswordLinkSent(
  FTArrange<MocksContainer> arrange,
) async {
  await arrangeBeforeWarpToForgotPassword(arrange);
}

Future<void> warpToResetPasswordLinkSent(FTWarp<MocksContainer> warp) async {
  await warpToForgotPassword(warp);

  when(
    () => warp.mocks.repositories.authRepository.sendResetPasswordLink(
      email: any(named: 'email'),
    ),
  ).thenAnswer((_) async {});

  await warp.userAction.enterText(
    find.byType(ForgotPassword_Input_Email),
    'foo@example.com',
  );
  await warp.testerAction.pumpAndSettle();

  await warp.userAction.tap(find.byType(ForgotPassword_Button_Submit));
  await warp.testerAction.pumpAndSettle();
}
