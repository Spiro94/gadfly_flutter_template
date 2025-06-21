import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../../../i18n/translations.g.dart';
import '../../../../util/validators.dart';

class SignIn_Input_Email extends StatelessWidget {
  const SignIn_Input_Email({required this.controller, super.key});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final label = context.t.signIn.form.email.label;
    final hint = context.t.signIn.form.email.hint;
    final emptyError = context.t.signIn.form.email.error.empty;
    final invalidError = context.t.signIn.form.email.error.invalid;

    return FTextFormField.email(
      controller: controller,
      label: Text(label),
      hint: hint,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return emptyError;
        }

        if (!InsideUtil_Validators.isEmailValid(value)) {
          return invalidError;
        }
        return null;
      },
    );
  }
}
