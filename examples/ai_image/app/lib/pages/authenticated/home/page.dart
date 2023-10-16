import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/theme/theme.dart';
import '../../../blocs/image_generation/bloc.dart';
// ATTENTION 1/4
import '../../../repositories/image_generation/repository.dart';
// ---
import 'widgets/connector/app_bar.dart';
// ATTENTION 2/3
import 'widgets/connector/avatar.dart';
// ---
import 'widgets/connector/sign_out_button.dart';

@RoutePage()
class Home_Page extends StatelessWidget {
  const Home_Page({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // ATTENTION 3/4
    return BlocProvider(
      create: (context) {
        return ImageGenerationBloc(
          imageGenerationRepository: context.read<ImageGenerationRepository>(),
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
              // ATTENTION 4/3
              const HomeC_Avatar(),
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
