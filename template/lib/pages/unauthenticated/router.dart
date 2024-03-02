import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../shared/widgets/connector/auth_status_change_listener.dart';

@RoutePage(name: 'Unauthenticated_Routes')
class Unauthenticated_Router extends StatelessWidget {
  const Unauthenticated_Router({super.key});

  @override
  Widget build(BuildContext context) {
    return const SharedC_AuthStatusChangeListener(
      child: AutoRouter(),
    );
  }
}
