import 'package:flutter/material.dart';

import '../../../../../i18n/translations.g.dart';
import '../../../../../shared/validators.dart';

class SignUpC_PasswordTextField extends StatelessWidget {
  const SignUpC_PasswordTextField({
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
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        label: Text(
          context.t.signUp.form.password.placeholder,
        ),
      ),
      obscureText: true,
      onFieldSubmitted: onSubmitted,
      validator: (value) {
        if (!isPasswordValid(value!)) {
          return context.t.signUp.form.password.error.invalid;
        }

        return null;
      },
    );
  }
}
