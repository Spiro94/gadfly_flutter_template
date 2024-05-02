import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../shared/widgets/auth_status_change_listener.dart';

@RoutePage(name: 'Unauthenticated_Routes')
class Unauthenticated_Router extends StatelessWidget
    implements AutoRouteWrapper {
  const Unauthenticated_Router({super.key});

  @override
  Widget wrappedRoute(BuildContext context) {
    return Shared_AuthStatusChangeListener(child: this);
  }

  @override
  Widget build(BuildContext context) {
    return const AutoRouter();
  }
}
