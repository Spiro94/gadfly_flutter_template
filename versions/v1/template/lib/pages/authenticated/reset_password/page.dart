import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../app/theme/theme.dart';
import 'widgets/connector/app_bar.dart';

@RoutePage()
class ResetPassword_Page extends StatelessWidget {
  const ResetPassword_Page({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const ResetPassword_Scaffold();
  }
}

class ResetPassword_Scaffold extends StatelessWidget {
  const ResetPassword_Scaffold({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const ResetPasswordC_AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(context.spacings.large),
          child: const Column(
            children: [],
          ),
        ),
      ),
    );
  }
}
