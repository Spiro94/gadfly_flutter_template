import 'package:flutter/material.dart';

import '../../../theme/theme.dart';

class SharedD_BodyContainer extends StatelessWidget {
  const SharedD_BodyContainer({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          constraints:
              BoxConstraints(maxWidth: context.tokens.breakpoint.large),
          child: SizedBox(
            width: double.infinity,
            child: child,
          ),
        ),
      ),
    );
  }
}
