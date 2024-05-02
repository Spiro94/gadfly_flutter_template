import 'package:flutter/material.dart';

import '../../../../../i18n/translations.g.dart';
import '../../../../shared/widgets/app_bar.dart';
import '../../../../theme/theme.dart';
import 'sign_out_button.dart';

class Home_AppBar extends StatelessWidget implements PreferredSizeWidget {
  const Home_AppBar({super.key});

  @override
  Size get preferredSize => const Size(double.infinity, kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Shared_AppBar(
      title: Text(context.t.home.title),
      centerTitle: true,
      automaticallyImplyLeading: false,
      actions: [
        const Home_SignOutButton(),
        SizedBox(
          width: context.tokens.spacing.medium,
        ),
      ],
    );
  }
}
