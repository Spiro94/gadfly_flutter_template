import 'package:flutter/material.dart';

import '../../../../../../i18n/translations.g.dart';
import '../../../../../shared/widgets/dumb/app_bar.dart';

class ResetPasswordC_AppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const ResetPasswordC_AppBar({super.key});

  @override
  Size get preferredSize => const Size(double.infinity, kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return SharedD_AppBar(
      title: Text(context.t.resetPassword.title),
      centerTitle: true,
      automaticallyImplyLeading: true,
    );
  }
}
