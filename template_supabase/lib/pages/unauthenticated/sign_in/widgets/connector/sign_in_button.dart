import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../blocs/sign_in/bloc.dart';
import '../../../../../blocs/sign_in/state.dart';
import '../../../../../i18n/translations.g.dart';
import '../../../../../shared/widgets/dumb/button.dart';

class SignInC_SignInButton extends StatelessWidget {
  const SignInC_SignInButton({
    required this.areFieldsAnswered,
    required this.onPressed,
    super.key,
  });

  final bool areFieldsAnswered;
  final VoidCallback onPressed;

  SharedD_ButtonStatus getButtonStatus(
    SignInStatus status,
  ) {
    if (!areFieldsAnswered) {
      return SharedD_ButtonStatus.disabled;
    }

    switch (status) {
      case SignInStatus.loading:
        return SharedD_ButtonStatus.loading;

      case SignInStatus.error:
      case SignInStatus.idle:
        return SharedD_ButtonStatus.enabled;
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = context.watch<SignInBloc>().state.status;
    final buttonStatus = getButtonStatus(status);

    return SharedD_Button(
      buttonType: SharedD_ButtonType.primary,
      status: buttonStatus,
      onPressed: onPressed,
      child: Text(context.t.signIn.ctas.signIn.label),
    );
  }
}
