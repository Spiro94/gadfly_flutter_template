import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../../../i18n/translations.g.dart';

class EmailVerificationLinkSent_Text_Subtitle extends StatelessWidget {
  const EmailVerificationLinkSent_Text_Subtitle({super.key});

  @override
  Widget build(BuildContext context) {
    final subtitle = context.t.emailVerificationLinkSent.subtitle;

    return Text(subtitle, style: context.theme.typography.lg);
  }
}
