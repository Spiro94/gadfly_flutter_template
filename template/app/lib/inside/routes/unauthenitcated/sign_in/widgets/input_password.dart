import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../../../i18n/translations.g.dart';

class SignIn_Input_Password extends StatelessWidget {
  const SignIn_Input_Password({required this.controller, super.key});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final label = context.t.signIn.form.password.label;
    final emptyError = context.t.signIn.form.password.error.empty;

    return FTextFormField.password(
      controller: controller,
      label: Text(label),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return emptyError;
        }

        return null;
      },
    );
  }
}
