import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../blocs/forgot_password/bloc.dart';
import '../../../../../../blocs/forgot_password/state.dart';
import '../../../../../../i18n/translations.g.dart';
import '../../../../../../theme/theme.dart';

class ForgotPasswordConfirmationC_ForgotPasswordStatusChangeListener
    extends StatelessWidget {
  const ForgotPasswordConfirmationC_ForgotPasswordStatusChangeListener({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        switch (state.status) {
          case ForgotPasswordStatus.resendLinkError:
            final sm = ScaffoldMessenger.of(context);
            sm.hideCurrentSnackBar();
            sm.showSnackBar(
              SnackBar(
                backgroundColor: context.tokens.color.error.container,
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      context
                          .t.forgotPasswordConfirmation.ctas.resendEmail.error,
                      style: TextStyle(
                        color: context.tokens.color.error.onContainer,
                      ),
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
                backgroundColor: context.tokens.color.success.container,
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      context.t.forgotPasswordConfirmation.ctas.resendEmail
                          .success,
                      style: TextStyle(
                        color: context.tokens.color.success.onContainer,
                      ),
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
