import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../app/theme/theme.dart';
import '../../../blocs/sign_up/bloc.dart';
import '../../../repositories/auth/repository.dart';
import 'widgets/connector/app_bar.dart';
import 'widgets/molecule/sign_up_form.dart';

@RoutePage()
class SignUp_Page extends StatelessWidget {
  const SignUp_Page({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return SignUpBloc(authRepository: context.read<AuthRepository>());
      },
      child: const SignUp_Scaffold(),
    );
  }
}

class SignUp_Scaffold extends StatelessWidget {
  const SignUp_Scaffold({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SignInC_AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(context.spacings.large),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              SignUpM_SignUnForm(),
            ],
          ),
        ),
      ),
    );
  }
}
