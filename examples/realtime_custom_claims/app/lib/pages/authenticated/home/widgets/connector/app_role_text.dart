import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../blocs/custom_claims/bloc.dart';
import '../../../../../i18n/translations.g.dart';

class HomeC_AppRoleText extends StatelessWidget {
  const HomeC_AppRoleText({super.key});

  @override
  Widget build(BuildContext context) {
    final customClaimsBloc = context.watch<CustomClaimsBloc>();
    final appRoleClaim = customClaimsBloc.state.appRoleClaim;

    return Text(context.t.home.appRole(role: appRoleClaim ?? ''));
  }
}
