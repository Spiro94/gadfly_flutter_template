import 'package:flutter/material.dart';

import '../../../../i18n/translations.g.dart';
import '../../../../shared/validators.dart';
import '../../../../shared/widgets/input.dart';

class SignIn_EmailInput extends StatelessWidget {
  const SignIn_EmailInput({
    required this.controller,
    required this.focusNode,
    super.key,
  });

  final TextEditingController controller;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return Shared_Input(
      controller: controller,
      focusNode: focusNode,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      label: context.t.signIn.form.email.placeholder,
      onValidate: (value) {
        if (!isEmailValid(value!)) {
          return context.t.signIn.form.email.error.invalid;
        }

        return null;
      },
    );
  }
}
