import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../blocs/reset_password/bloc.dart';
import '../../../../../blocs/reset_password/state.dart';
import '../../../../../i18n/translations.g.dart';
import '../../../../../shared/widgets/dumb/button.dart';

class ResetPasswordC_ResetPasswordButton extends StatelessWidget {
  const ResetPasswordC_ResetPasswordButton({
    required this.onPressed,
    required this.areFieldsAnswered,
    super.key,
  });

  final VoidCallback onPressed;
  final bool areFieldsAnswered;

  SharedD_ButtonStatus getButtonStatus(ResetPasswordStatus status) {
    if (!areFieldsAnswered) {
      return SharedD_ButtonStatus.disabled;
    }
    switch (status) {
      case ResetPasswordStatus.loading:
      case ResetPasswordStatus.error:
      case ResetPasswordStatus.success:
        return SharedD_ButtonStatus.loading;
      case ResetPasswordStatus.idle:
        return SharedD_ButtonStatus.enabled;
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = context.watch<ResetPasswordBloc>().state.status;
    final buttonStatus = getButtonStatus(status);

    return SharedD_Button(
      onPressed: onPressed,
      status: buttonStatus,
      buttonType: SharedD_ButtonType.primary,
      child: Text(context.t.resetPassword.ctas.resetPassword.label),
    );
  }
}
