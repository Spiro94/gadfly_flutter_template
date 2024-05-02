import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../blocs/forgot_password/bloc.dart';
import '../../../../../../blocs/forgot_password/state.dart';
import '../../../../../../i18n/translations.g.dart';
import '../../../../../../shared/widgets/dumb/button.dart';

class ForgotPasswordC_ResetPasswordButton extends StatelessWidget {
  const ForgotPasswordC_ResetPasswordButton({
    required this.areFieldsAnswered,
    required this.onPressed,
    super.key,
  });

  final bool areFieldsAnswered;
  final VoidCallback onPressed;

  SharedD_ButtonStatus getButtonStatus(
    ForgotPasswordStatus status,
  ) {
    if (!areFieldsAnswered) {
      return SharedD_ButtonStatus.disabled;
    }

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
      buttonType: SharedD_ButtonType.primary,
      status: buttonStatus,
      onPressed: onPressed,
      child: Text(context.t.forgotPassword.ctas.resetPassword.label),
    );
  }
}
