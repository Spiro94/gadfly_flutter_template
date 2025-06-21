import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';

import '../../../../outside/repositories/auth/repository.dart';
import '../../../../outside/theme/theme.dart';
import '../../../blocs/reset_password/bloc.dart';
import '../../../util/breakpoints.dart';
import '../../widgets/scaffold.dart';
import 'widgets/form_reset_password.dart';
import 'widgets/header.dart';
import 'widgets/listener_status_change.dart';

@RoutePage()
class ResetPassword_Page extends StatelessWidget implements AutoRouteWrapper {
  const ResetPassword_Page({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (context) {
        return ResetPassword_Bloc(
          authRepository: context.read<Auth_Repository>(),
        );
      },
      child: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Routes_Scaffold(
      breakpointType: InsideUtil_BreakpointType.constrained,
      scaffold: FScaffold(
        header: const ResetPassword_Header(),
        child: ResetPassword_Listener_StatusChange(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const ResetPassword_Form_ResetPassword(),
                SizedBox(height: context.tokens.spacing.medium),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
