import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../../../i18n/translations.g.dart';

class SignIn_Header extends StatelessWidget {
  const SignIn_Header({super.key});

  @override
  Widget build(BuildContext context) {
    final title = context.t.signIn.title;

    return FHeader(title: Text(title));
  }
}
