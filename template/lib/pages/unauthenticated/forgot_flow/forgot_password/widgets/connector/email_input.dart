import 'package:flutter/material.dart';

import '../../../../../../i18n/translations.g.dart';
import '../../../../../../shared/validators.dart';

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
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        label: Text(context.t.forgotPassword.form.email.placeholder),
      ),
      onFieldSubmitted: onSubmitted,
      validator: (value) {
        if (!isEmailValid(value!)) {
          return context.t.forgotPassword.form.email.error.invalid;
        }

        return null;
      },
    );
  }
}
