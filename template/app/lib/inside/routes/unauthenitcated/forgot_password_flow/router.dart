import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../outside/repositories/auth/repository.dart';
import '../../../blocs/reset_password/bloc.dart';

@RoutePage(name: 'ForgotPasswordFlow_Routes')
class ForgotPasswordFlow_Router extends StatelessWidget {
  const ForgotPasswordFlow_Router({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return ResetPassword_Bloc(
          authRepository: context.read<Auth_Repository>(),
        );
      },
      child: const AutoRouter(),
    );
  }
}
