import 'package:flutter/material.dart';

import '../../../../../i18n/translations.g.dart';
import '../../../../../shared/validators.dart';
import '../../../../../shared/widgets/dumb/input.dart';

class SignUpC_EmailInput extends StatelessWidget {
  const SignUpC_EmailInput({
    required this.controller,
    required this.focusNode,
    super.key,
  });

  final TextEditingController controller;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return SharedD_Input(
      controller: controller,
      focusNode: focusNode,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      label: context.t.signUp.form.email.placeholder,
      onValidate: (value) {
        if (!isEmailValid(value!)) {
          return context.t.signUp.form.email.error.invalid;
        }

        return null;
      },
    );
  }
}
