import 'package:app_theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../blocs/auth/bloc.dart';
import '../../../../../blocs/auth/state.dart';
import '../../../../../i18n/translations.g.dart';

class SignInL_OnAuthSignInStatusChange extends StatelessWidget {
  const SignInL_OnAuthSignInStatusChange({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          previous.signInStatus != current.signInStatus,
      listener: (context, state) {
        switch (state.signInStatus) {
          case AuthSignInStatus.error:
            final sm = ScaffoldMessenger.of(context);
            sm.hideCurrentSnackBar();
            sm.showSnackBar(
              SnackBar(
                backgroundColor: context.theme.colors.warning.mid,
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      context.t.signIn.snackbar.signInError,
                    ),
                  ],
                ),
              ),
            );
          case AuthSignInStatus.idle:
            return;
        }
      },
      child: child,
    );
  }
}
