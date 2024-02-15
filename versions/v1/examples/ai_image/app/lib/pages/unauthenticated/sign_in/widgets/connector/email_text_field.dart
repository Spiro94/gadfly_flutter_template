import 'package:flutter/material.dart';

import '../../../../../i18n/translations.g.dart';
import '../../../../../shared/validators.dart';

class SignInC_EmailTextField extends StatelessWidget {
  const SignInC_EmailTextField({
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
        label: Text(context.t.signIn.form.email.placeholder),
      ),
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(nextFocusNode);
      },
      validator: (value) {
        if (!isEmailValid(value!)) {
          return context.t.signIn.form.email.error.invalid;
        }

        return null;
      },
    );
  }
}
