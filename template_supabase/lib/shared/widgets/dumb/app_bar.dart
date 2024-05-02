// coverage:ignore-file

import 'package:flutter/material.dart';

import '../../../theme/theme.dart';

class SharedD_AppBar extends StatelessWidget implements PreferredSizeWidget {
  const SharedD_AppBar({
    required this.title,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.centerTitle = false,
    this.actions,
    super.key,
  });

  final Widget? leading;
  final Widget title;
  final bool automaticallyImplyLeading;
  final bool centerTitle;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size(double.infinity, kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final totalWidth = mq.size.width;
    final largeWidthBreakpoint = context.tokens.breakpoint.large;
    final paddingWidth = (totalWidth > largeWidthBreakpoint)
        ? (totalWidth - largeWidthBreakpoint) / 2
        : 0;

    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: paddingWidth.toDouble()),
      child: AppBar(
        backgroundColor: context.tokens.color.neutral.background,
        automaticallyImplyLeading: automaticallyImplyLeading,
        leading: leading,
        title: DefaultTextStyle(
          style: textTheme.titleLarge!,
          child: title,
        ),
        centerTitle: centerTitle,
        actions: actions,
      ),
    );
  }
}
