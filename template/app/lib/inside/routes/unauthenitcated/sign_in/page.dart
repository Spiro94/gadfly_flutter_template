import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';

import '../../../../outside/repositories/auth/repository.dart';
import '../../../../outside/theme/theme.dart';
import '../../../blocs/sign_in/bloc.dart';
import '../../../util/breakpoints.dart';
import '../../widgets/scaffold.dart';
import 'widgets/form_sign_in.dart';
import 'widgets/header.dart';
import 'widgets/link_sign_up.dart';
import 'widgets/listener_status_change.dart';

@RoutePage()
class SignIn_Page extends StatelessWidget implements AutoRouteWrapper {
  const SignIn_Page({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return SignIn_Bloc(authRepository: context.read<Auth_Repository>());
      },
      child: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Routes_Scaffold(
      breakpointType: InsideUtil_BreakpointType.constrained,
      scaffold: FScaffold(
        header: const SignIn_Header(),
        child: SignIn_Listener_StatusChange(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SignIn_Form_SignIn(),
                SizedBox(height: context.tokens.spacing.medium),
                const SignIn_Link_SignUp(),
                SizedBox(height: context.tokens.spacing.large),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
