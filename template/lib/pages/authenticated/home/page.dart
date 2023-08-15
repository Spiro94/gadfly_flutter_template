import 'package:app_theme/app_theme.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'widgets/connector/sign_out_button.dart';
import 'widgets/connector/signed_in_at_text.dart';

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
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const HomeC_SignedInAtText(),
            SizedBox(
              height: context.theme.spacings.medium,
            ),
            const HomeC_SignOutButton(),
          ],
        ),
      ),
    );
  }
}
