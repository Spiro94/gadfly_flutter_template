import 'package:flutter/material.dart';

import '../../../../../i18n/translations.g.dart';

class SignInC_PasswordInput extends StatelessWidget {
  const SignInC_PasswordInput({
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
          context.t.signIn.form.password.placeholder,
        ),
      ),
      obscureText: true,
      onFieldSubmitted: onSubmitted,
    );
  }
}
