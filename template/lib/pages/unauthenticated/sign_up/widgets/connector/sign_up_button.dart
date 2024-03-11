import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../blocs/sign_up/bloc.dart';
import '../../../../../blocs/sign_up/state.dart';
import '../../../../../i18n/translations.g.dart';
import '../../../../../shared/widgets/dumb/button.dart';

class SignUpC_SignUpButton extends StatelessWidget {
  const SignUpC_SignUpButton({
    required this.areFieldsAnswered,
    required this.onPressed,
    super.key,
  });

  final bool areFieldsAnswered;
  final VoidCallback onPressed;

  SharedD_ButtonStatus getButtonStatus(
    SignUpStatus status,
  ) {
    if (!areFieldsAnswered) {
      return SharedD_ButtonStatus.disabled;
    }

    switch (status) {
      case SignUpStatus.loading:
        return SharedD_ButtonStatus.loading;

      case SignUpStatus.error:
      case SignUpStatus.idle:
        return SharedD_ButtonStatus.enabled;
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = context.watch<SignUpBloc>().state.status;
    final buttonStatus = getButtonStatus(status);

    return SharedD_Button(
      buttonType: SharedD_ButtonType.primary,
      status: buttonStatus,
      onPressed: onPressed,
      child: Text(context.t.signUp.ctas.signUp.label),
    );
  }
}
