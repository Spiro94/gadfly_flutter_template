import 'package:flutter/material.dart';

import '../../../../../i18n/translations.g.dart';
import '../../../../../shared/validators.dart';
import '../../../../../shared/widgets/dumb/input.dart';

class SignUpC_PasswordInput extends StatelessWidget {
  const SignUpC_PasswordInput({
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
      textInputAction: TextInputAction.done,
      label: context.t.signUp.form.password.placeholder,
      obscureText: true,
      onFieldSubmitted: onSubmitted,
      onValidate: (value) {
        if (!isPasswordValid(value!)) {
          return context.t.signUp.form.password.error.invalid;
        }

        return null;
      },
    );
  }
}
