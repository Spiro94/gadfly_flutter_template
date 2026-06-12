import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../../../../outside/theme/theme.dart';
import '../../../../util/breakpoints.dart';
import '../../../widgets/scaffold.dart';
import 'widgets/header.dart';
import 'widgets/link_resend.dart';
import 'widgets/listener_status_change.dart';
import 'widgets/text_subtitle.dart';

@RoutePage()
class ResetPasswordLinkSent_Page extends StatelessWidget
    implements AutoRouteWrapper {
  const ResetPasswordLinkSent_Page({@QueryParam() this.email, super.key});

  final String? email;

  @override
  Widget wrappedRoute(BuildContext context) {
    return this;
  }

  @override
  Widget build(BuildContext context) {
    return Routes_Scaffold(
      breakpointType: InsideUtil_BreakpointType.constrained,
      scaffold: FScaffold(
        header: const ResetPasswordLinkSent_Header(),
        child: ResetPasswordLinkSent_Listener_StatusChange(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: context.tokens.spacing.medium),
                const ResetPasswordLinkSent_Text_Subtitle(),
                const FDivider(),
                const ResetPasswordLinkSent_Link_Resend(),
                SizedBox(height: context.tokens.spacing.medium),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
