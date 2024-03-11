import 'package:flutter/material.dart';

import '../../../../../i18n/translations.g.dart';
import '../../../../../shared/validators.dart';

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
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      onFieldSubmitted: onSubmitted,
      obscureText: true,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        label: Text(context.t.resetPassword.form.newPassword.placeholder),
      ),
      validator: (value) {
        if (!isPasswordValid(value!)) {
          return context.t.resetPassword.form.newPassword.error.invalid;
        }

        return null;
      },
    );
  }
}
