import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../../../app/router.dart';
import '../../../../../../i18n/translations.g.dart';

class ForgotPasswordConfirmationC_AppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const ForgotPasswordConfirmationC_AppBar({super.key});

  @override
  Size get preferredSize => const Size(double.infinity, kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(context.t.signUp.title),
      centerTitle: true,

      // We don't want to allow the user to go back to the previous page, so
      // overwritting the back button to go to the sign in page.
      leading: BackButton(
        onPressed: () {
          context.router.navigate(const SignIn_Route());
        },
      ),
    );
  }
}
