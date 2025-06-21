import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';

import '../../../../outside/repositories/auth/repository.dart';
import '../../../../outside/theme/theme.dart';
import '../../../blocs/sign_up/bloc.dart';
import '../../../util/breakpoints.dart';
import '../../widgets/scaffold.dart';
import 'widgets/form_sign_up.dart';
import 'widgets/header.dart';
import 'widgets/link_resend_email_verification.dart';
import 'widgets/listener_status_change.dart';

@RoutePage()
class SignUp_Page extends StatelessWidget implements AutoRouteWrapper {
  const SignUp_Page({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return SignUp_Bloc(authRepository: context.read<Auth_Repository>());
      },
      child: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Routes_Scaffold(
      breakpointType: InsideUtil_BreakpointType.constrained,
      scaffold: FScaffold(
        header: const SignUp_Header(),
        child: SignUp_Listener_StatusChange(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SignUp_Form_SignUp(),
                const FDivider(),
                const SignUp_Link_ResendEmailVerification(),
                SizedBox(height: context.tokens.spacing.medium),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
