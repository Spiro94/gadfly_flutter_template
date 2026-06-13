import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';

import '../../../../../../outside/theme/theme.dart';
import '../../../../../blocs/reset_password/bloc.dart';
import '../../../../../blocs/reset_password/events.dart';
import '../../../../../i18n/translations.g.dart';

class ResetPasswordLinkSent_Link_Resend extends StatelessWidget {
  const ResetPasswordLinkSent_Link_Resend({super.key});

  @override
  Widget build(BuildContext context) {
    final question = context.t.resetPasswordLinkSent.resend.question;
    final action = context.t.resetPasswordLinkSent.resend.action;
    final email = context.routeData.queryParams.getString('email');

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      runSpacing: context.tokens.spacing.xSmall,
      spacing: context.tokens.spacing.xSmall,
      children: [
        Text(question),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FTappable(
              onPress: () {
                context.read<ResetPassword_Bloc>().add(
                  ResetPassword_Event_ResendResetPasswordLink(email: email),
                );
              },
              child: Text(
                action,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
