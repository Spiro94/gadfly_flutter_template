import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../shared/widgets/body_container.dart';
import '../../../theme/theme.dart';
import 'widgets/app_bar.dart';

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
      appBar: const Home_AppBar(),
      body: Shared_BodyContainer(
        child: Padding(
          padding: EdgeInsets.all(context.tokens.spacing.large),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: MediaQuery.of(context).padding.bottom,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
