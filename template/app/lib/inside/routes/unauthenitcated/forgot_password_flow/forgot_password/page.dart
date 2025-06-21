import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../../../../outside/theme/theme.dart';
import '../../../../util/breakpoints.dart';
import '../../../widgets/scaffold.dart';
import 'widgets/form_reset_password_request.dart';
import 'widgets/header.dart';
import 'widgets/listener_status_change.dart';

@RoutePage()
class ForgotPassword_Page extends StatelessWidget implements AutoRouteWrapper {
  const ForgotPassword_Page({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return this;
  }

  @override
  Widget build(BuildContext context) {
    return Routes_Scaffold(
      breakpointType: InsideUtil_BreakpointType.constrained,
      scaffold: FScaffold(
        header: const ForgotPassword_Header(),
        child: ForgotPassword_Listener_StatusChange(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const ForgotPassword_Form_ResetPasswordRequest(),
                SizedBox(height: context.tokens.spacing.medium),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
