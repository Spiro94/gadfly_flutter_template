import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

import '../../util/breakpoints.dart';

class Routes_Scaffold extends StatelessWidget {
  const Routes_Scaffold({
    required this.breakpointType,
    required this.scaffold,
    super.key,
  });

  final InsideUtil_BreakpointType breakpointType;
  final FScaffold scaffold;

  @override
  Widget build(BuildContext context) {
    final horizontalInset = InsideUtil_Breakpoints.getHorizontalInset(
      breakpointType: breakpointType,
      context: context,
    );

    final bacgkroundColor = context.theme.scaffoldStyle.backgroundColor;

    return Stack(
      children: [
        const SizedBox.expand(),
        Positioned.fill(
          left: horizontalInset,
          right: horizontalInset,
          child: Scaffold(backgroundColor: bacgkroundColor, body: scaffold),
        ),
      ],
    );
  }
}
