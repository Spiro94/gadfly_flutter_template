import 'package:flutter/material.dart';

import '../../../../../i18n/translations.g.dart';
import '../../../../../shared/validators.dart';

class SignUpC_EmailInput extends StatelessWidget {
  const SignUpC_EmailInput({
    required this.controller,
    required this.focusNode,
    required this.nextFocusNode,
    super.key,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final FocusNode nextFocusNode;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        label: Text(context.t.signUp.form.email.placeholder),
      ),
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(nextFocusNode);
      },
      validator: (value) {
        if (!isEmailValid(value!)) {
          return context.t.signUp.form.email.error.invalid;
        }

        return null;
      },
    );
  }
}
