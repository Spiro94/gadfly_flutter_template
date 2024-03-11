import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../blocs/forgot_password/bloc.dart';
import '../../../../../../blocs/forgot_password/event.dart';
import '../../../../../../blocs/forgot_password/state.dart';
import '../../../../../../i18n/translations.g.dart';
import '../../../../../../shared/widgets/dumb/button.dart';

class ForgotPasswordConfirmationC_ResendEmailButton extends StatelessWidget {
  const ForgotPasswordConfirmationC_ResendEmailButton({
    required this.email,
    super.key,
  });

  final String email;

  SharedD_ButtonStatus getButtonStatus(
    ForgotPasswordStatus status,
  ) {
    switch (status) {
      case ForgotPasswordStatus.loading:
        return SharedD_ButtonStatus.loading;

      case ForgotPasswordStatus.sendLinkError:
      case ForgotPasswordStatus.sendLinkSuccess:
      case ForgotPasswordStatus.resendLinkError:
      case ForgotPasswordStatus.resendLinkSuccess:
      case ForgotPasswordStatus.idle:
        return SharedD_ButtonStatus.enabled;
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = context.watch<ForgotPasswordBloc>().state.status;
    final buttonStatus = getButtonStatus(status);

    return SharedD_Button(
      onPressed: () {
        context.read<ForgotPasswordBloc>().add(
              ForgotPasswordEvent_ResendForgotPassword(email: email),
            );
      },
      status: buttonStatus,
      buttonType: SharedD_ButtonType.outlined,
      child: Text(context.t.forgotPasswordConfirmation.ctas.resendEmail.label),
    );
  }
}
