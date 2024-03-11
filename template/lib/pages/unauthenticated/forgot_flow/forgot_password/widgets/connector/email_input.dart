import 'package:flutter/material.dart';

import '../../../../../../i18n/translations.g.dart';
import '../../../../../../shared/validators.dart';
import '../../../../../../shared/widgets/dumb/input.dart';

class ForgotPasswordC_EmailInput extends StatelessWidget {
  const ForgotPasswordC_EmailInput({
    required this.controller,
    required this.focusNode,
    required this.onSubmitted,
    super.key,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final void Function(String value) onSubmitted;

  @override
  Widget build(BuildContext context) {
    return SharedD_Input(
      controller: controller,
      focusNode: focusNode,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.done,
      label: context.t.forgotPassword.form.email.placeholder,
      onFieldSubmitted: onSubmitted,
      onValidate: (value) {
        if (!isEmailValid(value!)) {
          return context.t.forgotPassword.form.email.error.invalid;
        }

        return null;
      },
    );
  }
}
