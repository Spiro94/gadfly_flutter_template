import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../widgets/listener_auth_status_change.dart';
import '../widgets/listener_supabase_auth_change.dart';

@RoutePage(name: 'Authenticated_Routes')
class Authenticated_Router extends StatelessWidget {
  const Authenticated_Router({super.key});

  @override
  Widget build(BuildContext context) {
    return const Routes_Listener_SupabaseAuthChange(
      child: Routes_Listener_AuthStatusChange(child: AutoRouter()),
    );
  }
}
