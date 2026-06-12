import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../../../../i18n/translations.g.dart';
import '../../../../router.dart';

class ResetPasswordLinkSent_Header extends StatelessWidget {
  const ResetPasswordLinkSent_Header({super.key});

  @override
  Widget build(BuildContext context) {
    final title = context.t.resetPasswordLinkSent.title;

    return FHeader.nested(
      title: Text(title),
      prefixes: [
        FHeaderAction.back(
          onPress: () {
            context.router.navigate(const SignIn_Route());
          },
        ),
      ],
    );
  }
}
