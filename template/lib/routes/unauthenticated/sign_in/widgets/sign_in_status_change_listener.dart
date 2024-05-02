import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../blocs/sign_in/bloc.dart';
import '../../../../blocs/sign_in/state.dart';
import '../../../../i18n/translations.g.dart';
import '../../../../theme/theme.dart';

class SignIn_SignInStatusChangeListener extends StatelessWidget {
  const SignIn_SignInStatusChangeListener({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignInBloc, SignInState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        switch (state.status) {
          case SignInStatus.error:
            final sm = ScaffoldMessenger.of(context);
            sm.hideCurrentSnackBar();
            sm.showSnackBar(
              SnackBar(
                backgroundColor: context.tokens.color.error.container,
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      context.t.signIn.ctas.signIn.error,
                      style: TextStyle(
                        color: context.tokens.color.error.onContainer,
                      ),
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
