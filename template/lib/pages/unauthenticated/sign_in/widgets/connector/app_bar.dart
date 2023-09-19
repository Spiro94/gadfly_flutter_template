import 'package:flutter/material.dart';

import '../../../../../i18n/translations.g.dart';

class SignUpC_AppBar extends StatelessWidget implements PreferredSizeWidget {
  const SignUpC_AppBar({super.key});

  @override
  Size get preferredSize => const Size(double.infinity, kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(context.t.signIn.title),
      centerTitle: true,
      automaticallyImplyLeading: false,
    );
  }
}
