import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:forui/forui.dart';

import '../../../../outside/repositories/auth/repository.dart';
import '../../../../outside/theme/theme.dart';
import '../../../blocs/sign_up/bloc.dart';
import '../../../util/breakpoints.dart';
import '../../widgets/scaffold.dart';
import 'widgets/header.dart';
import 'widgets/text_subtitle.dart';

@RoutePage()
class EmailVerificationLinkSent_Page extends StatelessWidget
    implements AutoRouteWrapper {
  const EmailVerificationLinkSent_Page({super.key});

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
        header: const EmailVerificationLinkSent_Header(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: context.tokens.spacing.medium),
              const EmailVerificationLinkSent_Text_Subtitle(),
              SizedBox(height: context.tokens.spacing.medium),
            ],
          ),
        ),
      ),
    );
  }
}
