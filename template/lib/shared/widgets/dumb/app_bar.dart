import 'package:flutter/material.dart';

class SharedD_AppBar extends StatelessWidget implements PreferredSizeWidget {
  const SharedD_AppBar({
    required this.title,
    this.leading,
    this.automaticallyImplyLeading = true,
    super.key,
  });

  final Widget? leading;
  final String title;
  final bool automaticallyImplyLeading;

  @override
  Size get preferredSize => const Size(double.infinity, kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: leading,
      title: Text(title),
      centerTitle: true,
    );
  }
}
