import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../blocs/forgot_password/bloc.dart';
import '../../../repositories/auth/repository.dart';

@RoutePage(name: 'ForgotFlow_Routes')
class ForgotFlow_Router extends StatelessWidget {
  const ForgotFlow_Router({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return ForgotPasswordBloc(
          authRepository: context.read<AuthRepository>(),
        );
      },
      child: const AutoRouter(),
    );
  }
}
