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

  SharedD_Button_Status getButtonStatus(
    SignInStatus status,
  ) {
    if (!areFieldsAnswered) {
      return SharedD_Button_Status.disabled;
    }

    switch (status) {
      case SignInStatus.loading:
        return SharedD_Button_Status.loading;

      case SignInStatus.idle:
      case SignInStatus.error:
        return SharedD_Button_Status.enabled;
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = context.watch<SignInBloc>().state.status;
    final buttonStatus = getButtonStatus(status);

    return SharedD_Button(
      status: buttonStatus,
      label: context.t.signIn.ctas.signIn.label,
      onPressed: onPressed,
    );
  }
}
