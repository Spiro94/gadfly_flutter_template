import 'package:flutter/material.dart';

import '../../../../../../i18n/translations.g.dart';

class ForgotPasswordConfirmationC_SubtitleText extends StatelessWidget {
  const ForgotPasswordConfirmationC_SubtitleText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      context.t.forgotPasswordConfirmation.subtitle,
      style: Theme.of(context).textTheme.labelLarge,
    );
  }
}
