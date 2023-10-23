import 'package:flutter/material.dart';

import '../../../../../i18n/translations.g.dart';

class SignInC_AppBar extends StatelessWidget implements PreferredSizeWidget {
  const SignInC_AppBar({super.key});

  @override
  Size get preferredSize => const Size(double.infinity, kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(context.t.signUp.title),
      centerTitle: true,
      automaticallyImplyLeading: true,
    );
  }
}
