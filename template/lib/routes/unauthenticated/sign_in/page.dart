// ignore_for_file: lines_longer_than_80_chars

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/auth/bloc.dart';
import '../../../blocs/auth/event.dart';
import '../../../blocs/sign_in/bloc.dart';
import '../../../repositories/auth/repository.dart';
import '../../../shared/widgets/body_container.dart';
import '../../../theme/theme.dart';
import 'widgets/app_bar.dart';
import 'widgets/sign_in_form.dart';
import 'widgets/sign_in_status_change_listener.dart';

@RoutePage()
class SignIn_Page extends StatelessWidget {
  const SignIn_Page({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignInBloc(
        onSaveAccessToken: (accessToken) => context
            .read<AuthBloc>()
            .add(AuthEvent_AccessTokenAdded(accessToken: accessToken)),
        authRepository: context.read<AuthRepository>(),
      ),
      child: const SignIn_Scaffold(),
    );
  }
}

class SignIn_Scaffold extends StatelessWidget {
  const SignIn_Scaffold({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SignIn_SignInStatusChangeListener(
      child: Scaffold(
        appBar: const SignUp_AppBar(),
        body: Shared_BodyContainer(
          child: Padding(
            padding: EdgeInsets.all(context.tokens.spacing.large),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SignIn_SignInForm(),
                SizedBox(
                  height: MediaQuery.of(context).padding.bottom,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
