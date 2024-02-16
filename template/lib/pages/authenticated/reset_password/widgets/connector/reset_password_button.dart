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

  SharedD_Button_Status getButtonStatus(ResetPasswordStatus status) {
    if (!areFieldsAnswered) {
      return SharedD_Button_Status.disabled;
    }
    switch (status) {
      case ResetPasswordStatus.loading:
      case ResetPasswordStatus.error:
      case ResetPasswordStatus.success:
        return SharedD_Button_Status.loading;
      case ResetPasswordStatus.idle:
        return SharedD_Button_Status.enabled;
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = context.watch<ResetPasswordBloc>().state.status;
    final buttonStatus = getButtonStatus(status);

    return SharedD_Button(
      onPressed: onPressed,
      label: context.t.resetPassword.ctas.resetPassword.label,
      status: buttonStatus,
    );
  }
}
