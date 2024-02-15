import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
// ATTENTION 1/5
import 'package:flutter_bloc/flutter_bloc.dart';
// ---
import '../../../app/theme/theme.dart';
// ATTENTION 2/5
import '../../../blocs/custom_claims/bloc.dart';
import '../../../blocs/custom_claims/event.dart';
import '../../../repositories/custom_claims/repository.dart';
// ---
import 'widgets/connector/app_bar.dart';
// ATTENTION 3/5
import 'widgets/connector/app_role_text.dart';
// --
import 'widgets/connector/sign_out_button.dart';

@RoutePage()
class Home_Page extends StatelessWidget {
  const Home_Page({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // ATTENTION 4/5
    return BlocProvider(
      create: (context) {
        return CustomClaimsBloc(
          customClaimsRepository: context.read<CustomClaimsRepository>(),
        )..add(
            CustomClaimsEvent_Initialize(),
          );
      },
      child: const Home_Scaffold(),
    );
    // ---
  }
}

class Home_Scaffold extends StatelessWidget {
  const Home_Scaffold({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeC_AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(context.spacings.large),
          child: Column(
            children: [
              // ATTENTION 5/5
              const HomeC_AppRoleText(),
              SizedBox(
                height: context.spacings.large,
              ),
              // ---
              const HomeC_SignOutButton(),
            ],
          ),
        ),
      ),
    );
  }
}
