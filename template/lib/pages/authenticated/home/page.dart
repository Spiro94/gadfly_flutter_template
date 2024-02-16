import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../theme/theme.dart';
import 'widgets/connector/app_bar.dart';
import 'widgets/connector/sign_out_button.dart';

@RoutePage()
class Home_Page extends StatelessWidget {
  const Home_Page({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Home_Scaffold();
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
          padding: EdgeInsets.all(context.tokens.spacing.large),
          child: const Column(
            children: [
              HomeC_SignOutButton(),
            ],
          ),
        ),
      ),
    );
  }
}
