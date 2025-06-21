import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../../util/breakpoints.dart';
import '../../widgets/scaffold.dart';
import 'widgets/header.dart';

@RoutePage()
class Home_Page extends StatelessWidget implements AutoRouteWrapper {
  const Home_Page({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return this;
  }

  @override
  Widget build(BuildContext context) {
    return const Routes_Scaffold(
      breakpointType: InsideUtil_BreakpointType.constrained,
      scaffold: FScaffold(
        header: Home_Header(),
        child: SingleChildScrollView(child: Column(children: [])),
      ),
    );
  }
}
