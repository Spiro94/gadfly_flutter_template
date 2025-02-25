import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

enum IntenralUtil_BreakpointType {
  constrained,
  unconstrained,
}

class InternalUtil_Breakpoints {
  static double getContentWidth({
    required IntenralUtil_BreakpointType breakpointType,
    required BuildContext context,
  }) {
    final breakpoints = context.theme.breakpoints;
    final width = MediaQuery.sizeOf(context).width;

    switch (breakpointType) {
      case IntenralUtil_BreakpointType.constrained:
        return switch (width) {
          _ when width > breakpoints.xl2 => breakpoints.md,
          _ when width > breakpoints.xl => breakpoints.md,
          _ when width > breakpoints.lg => breakpoints.md,
          _ when width > breakpoints.md => breakpoints.md,
          _ when width > breakpoints.sm => breakpoints.sm,
          _ => width,
        };

      case IntenralUtil_BreakpointType.unconstrained:
        return switch (width) {
          _ => width,
        };
    }
  }

  static double getHorizontalInset({
    required IntenralUtil_BreakpointType breakpointType,
    required BuildContext context,
  }) {
    final width = MediaQuery.sizeOf(context).width;

    final contentWidth = getContentWidth(
      breakpointType: breakpointType,
      context: context,
    );
    return (width - contentWidth) / 2;
  }
}
