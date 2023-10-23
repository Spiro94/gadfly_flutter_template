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

  SharedD_Button_Status getButtonStatus(
    SignUpStatus status,
  ) {
    if (!areFieldsAnswered) {
      return SharedD_Button_Status.disabled;
    }

    switch (status) {
      case SignUpStatus.loading:
        return SharedD_Button_Status.loading;

      case SignUpStatus.idle:
      case SignUpStatus.error:
        return SharedD_Button_Status.enabled;
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = context.watch<SignUpBloc>().state.status;
    final buttonStatus = getButtonStatus(status);

    return SharedD_Button(
      status: buttonStatus,
      label: context.t.signUp.ctas.signUp,
      onPressed: onPressed,
    );
  }
}
