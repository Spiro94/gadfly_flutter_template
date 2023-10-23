import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../../../app/router.dart';
import '../../../../../../i18n/translations.g.dart';

class ForgotPasswordC_AppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const ForgotPasswordC_AppBar({super.key});

  @override
  Size get preferredSize => const Size(double.infinity, kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(context.t.forgotPassword.title),
      centerTitle: true,

      // Note: we can't automatically imply leading because the nearest router
      // is at a different level than the SignInRoute and won't show a back
      // button.
      leading: BackButton(
        onPressed: () {
          context.router.navigate(const SignIn_Route());
        },
      ),
    );
  }
}
