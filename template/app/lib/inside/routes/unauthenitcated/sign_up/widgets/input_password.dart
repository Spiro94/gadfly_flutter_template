import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../../../i18n/translations.g.dart';
import '../../../../util/validators.dart';

class SignUp_Input_Password extends StatelessWidget {
  const SignUp_Input_Password({required this.controller, super.key});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final label = context.t.signUp.form.password.label;
    final emptyError = context.t.signUp.form.password.error.empty;
    final invalidError = context.t.signUp.form.password.error.invalid;

    return FTextFormField.password(
      controller: controller,
      label: Text(label),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return emptyError;
        }

        if (!InsideUtil_Validators.isPasswordValid(value)) {
          return invalidError;
        }
        return null;
      },
    );
  }
}
