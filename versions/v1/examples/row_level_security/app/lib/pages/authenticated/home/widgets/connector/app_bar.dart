import 'package:flutter/material.dart';

import '../../../../../../i18n/translations.g.dart';

class HomeC_AppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeC_AppBar({super.key});

  @override
  Size get preferredSize => const Size(double.infinity, kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(context.t.home.title),
      centerTitle: true,
      automaticallyImplyLeading: false,
    );
  }
}
