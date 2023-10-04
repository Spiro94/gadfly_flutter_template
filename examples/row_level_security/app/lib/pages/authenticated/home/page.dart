import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/theme/theme.dart';
import '../../../blocs/count/bloc.dart';
import '../../../blocs/count/event.dart';
import '../../../repositories/count/repository.dart';
import 'widgets/connector/app_bar.dart';
// ATTENTION 1/3
import 'widgets/connector/counter_text.dart';
import 'widgets/connector/decrement_button.dart';
import 'widgets/connector/increment_button.dart';
// ---
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
        return CountBloc(countRepository: context.read<CountRepository>())
          ..add(CountEvent_Initialize());
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
              Row(
                children: [
                  const HomeC_DecrementButton(),
                  SizedBox(
                    width: context.spacings.small,
                  ),
                  const HomeC_CounterText(),
                  SizedBox(
                    width: context.spacings.small,
                  ),
                  const HomeC_IncrementButton(),
                ],
              ),
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
