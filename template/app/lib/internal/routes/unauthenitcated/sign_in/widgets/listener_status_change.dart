import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';

import '../../../../blocs/sign_in/bloc.dart';
import '../../../../blocs/sign_in/state.dart';

class SignIn_Listener_StatusChange extends StatelessWidget {
  const SignIn_Listener_StatusChange({
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
          case SignInStatus.signInError:
            final scaffoldBackgroundColor =
                context.theme.scaffoldStyle.backgroundColor;
            if (state.errorMessage != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: scaffoldBackgroundColor,
                  content: FAlert(
                    title: Text(state.errorMessage!),
                    style: FAlertStyle.destructive,
                  ),
                ),
              );
            }
          case SignInStatus.signInInProgress:
          case SignInStatus.signInSuccess:
          case SignInStatus.idle:
        }
      },
      child: child,
    );
  }
}
