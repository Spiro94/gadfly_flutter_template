import 'package:flutter/material.dart';

import '../../../../../i18n/translations.g.dart';
import '../../../../../shared/validators.dart';
import '../../../../../shared/widgets/dumb/input.dart';

class ResetPasswordC_NewPasswordInput extends StatelessWidget {
  const ResetPasswordC_NewPasswordInput({
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
      keyboardType: TextInputType.text,
      onFieldSubmitted: onSubmitted,
      obscureText: true,
      textInputAction: TextInputAction.done,
      label: context.t.resetPassword.form.newPassword.placeholder,
      onValidate: (value) {
        if (!isPasswordValid(value!)) {
          return context.t.resetPassword.form.newPassword.error.invalid;
        }

        return null;
      },
    );
  }
}
