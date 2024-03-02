import 'package:flow_test/flow_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gadfly_flutter_template/pages/unauthenticated/forgot_flow/forgot_password/widgets/connector/email_text_field.dart';
import 'package:gadfly_flutter_template/pages/unauthenticated/forgot_flow/forgot_password/widgets/connector/reset_password_button.dart';
import 'package:mocktail/mocktail.dart';

import '../mocked_app.dart';
import 'to_forgot_password.dart';

Future<void> arrangeBeforeWarpToForgotPasswordConfirmation(
  FTArrange<MocksContainer> arrange,
) async {}

Future<void> warpToForgotPasswordConfirmation(
  FTWarp<MocksContainer> warp,
) async {
  await warpToForgotPassword(warp);

  await warp.userAction.enterText(
    find.byType(ForgotPasswordC_EmailTextField),
    'john@example.com',
  );
  await warp.testerAction.pumpAndSettle();

  when(
    () => warp.mocks.authRepository.forgotPassword(
      email: any(named: 'email'),
    ),
  ).thenAnswer((invocation) async {});

  await warp.userAction.tap(
    find.byType(ForgotPasswordC_ResetPasswordButton),
  );
  await warp.testerAction.pumpAndSettle();
}
