import 'package:flutter/material.dart';

import '../../../../i18n/translations.g.dart';
import '../../../../shared/widgets/app_bar.dart';

class SignUp_AppBar extends StatelessWidget implements PreferredSizeWidget {
  const SignUp_AppBar({super.key});

  @override
  Size get preferredSize => const Size(double.infinity, kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Shared_AppBar(
      title: Text(context.t.signIn.title),
      centerTitle: true,
      automaticallyImplyLeading: false,
    );
  }
}
