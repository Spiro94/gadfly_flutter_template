import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../blocs/forgot_password/bloc.dart';
import '../../../../../../blocs/forgot_password/state.dart';
import '../../../../../../i18n/translations.g.dart';

class ForgotPasswordConfirmationL_OnForgotPasswordStatusChange
    extends StatelessWidget {
  const ForgotPasswordConfirmationL_OnForgotPasswordStatusChange({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        final colorScheme = Theme.of(context).colorScheme;

        switch (state.status) {
          case ForgotPasswordStatus.resendLinkError:
            final sm = ScaffoldMessenger.of(context);
            sm.hideCurrentSnackBar();
            sm.showSnackBar(
              SnackBar(
                backgroundColor: colorScheme.errorContainer,
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      context
                          .t.forgotPasswordConfirmation.ctas.resendEmail.error,
                      style: TextStyle(color: colorScheme.onErrorContainer),
                    ),
                  ],
                ),
              ),
            );

          case ForgotPasswordStatus.resendLinkSuccess:
            final sm = ScaffoldMessenger.of(context);
            sm.hideCurrentSnackBar();
            sm.showSnackBar(
              SnackBar(
                backgroundColor: colorScheme.primaryContainer,
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      context.t.forgotPasswordConfirmation.ctas.resendEmail
                          .success,
                      style: TextStyle(color: colorScheme.onPrimaryContainer),
                    ),
                  ],
                ),
              ),
            );

          case ForgotPasswordStatus.sendLinkError:
          case ForgotPasswordStatus.sendLinkSuccess:
          case ForgotPasswordStatus.loading:
          case ForgotPasswordStatus.idle:
            return;
        }
      },
      child: child,
    );
  }
}
