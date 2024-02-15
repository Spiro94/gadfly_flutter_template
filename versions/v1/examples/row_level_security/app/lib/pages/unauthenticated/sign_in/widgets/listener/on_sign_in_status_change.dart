import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../blocs/sign_in/bloc.dart';
import '../../../../../blocs/sign_in/state.dart';
import '../../../../../i18n/translations.g.dart';

class SignInL_OnSignInStatusChange extends StatelessWidget {
  const SignInL_OnSignInStatusChange({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignInBloc, SignInState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        final colorScheme = Theme.of(context).colorScheme;

        switch (state.status) {
          case SignInStatus.error:
            final sm = ScaffoldMessenger.of(context);
            sm.hideCurrentSnackBar();
            sm.showSnackBar(
              SnackBar(
                backgroundColor: colorScheme.errorContainer,
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      context.t.signIn.ctas.error,
                      style: TextStyle(color: colorScheme.onErrorContainer),
                    ),
                  ],
                ),
              ),
            );

          case SignInStatus.loading:
          case SignInStatus.idle:
            return;
        }
      },
      child: child,
    );
  }
}
