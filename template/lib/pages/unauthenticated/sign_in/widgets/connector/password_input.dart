import 'package:flutter/material.dart';

import '../../../../../i18n/translations.g.dart';
import '../../../../../shared/widgets/dumb/input.dart';

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
    return SharedD_Input(
      controller: controller,
      focusNode: focusNode,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.done,
      label: context.t.signIn.form.password.placeholder,
      obscureText: true,
      onFieldSubmitted: onSubmitted,
    );
  }
}
