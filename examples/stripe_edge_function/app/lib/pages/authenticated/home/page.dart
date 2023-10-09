import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/theme/theme.dart';
// ATTENTION 1/3
import '../../../blocs/payments/bloc.dart';
import '../../../blocs/payments/event.dart';
// ---
import '../../../repositories/payments/repository.dart';
import 'widgets/connector/app_bar.dart';
import 'widgets/connector/create_stripe_account_button.dart';
import 'widgets/connector/sign_out_button.dart';

@RoutePage()
class Home_Page extends StatelessWidget {
  const Home_Page({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // ATTENTION 2/3
    return BlocProvider(
      create: (context) {
        return PaymentsBloc(
          paymentsRepository: context.read<PaymentsRepository>(),
        )..add(PaymentsEvent_Initialize());
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
              // ATTENTION 3/3
              const HomeC_CreateStripeAccountButton(),
              SizedBox(
                height: context.spacings.medium,
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
