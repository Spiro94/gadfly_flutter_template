import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

enum SharedD_Button_Status {
  enabled,
  loading,
  disabled,
}

enum SharedD_Button_Type {
  filled,
  outlined,
}

class SharedD_Button extends StatelessWidget {
  const SharedD_Button({
    required this.onPressed,
    required this.label,
    required this.status,
    super.key,
    this.buttonType = SharedD_Button_Type.filled,
  });

  final VoidCallback onPressed;
  final String label;
  final SharedD_Button_Status status;
  final SharedD_Button_Type buttonType;

  bool get isLoading => status == SharedD_Button_Status.loading;
  bool get isDisabled => status == SharedD_Button_Status.disabled;

  VoidCallback? get onPressedResolved {
    // - If disabled, remove callback
    // - If loading, then show button as normal, but remove effect from
    //   press
    // - If idle, then show button as normal and allow effect from press
    return isDisabled ? null : (isLoading ? () {} : onPressed);
  }

  Widget loadingChild({required Color color}) => SizedBox(
        height: 20, // Magic number
        width: 40,
        child: LoadingIndicator(
          indicatorType: Indicator.ballPulse,
          colors: [color],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    switch (buttonType) {
      case SharedD_Button_Type.filled:
        return FilledButton(
          onPressed: onPressedResolved,
          child: isLoading
              ? loadingChild(
                  color: theme.colorScheme.onPrimary,
                )
              : Text(label),
        );

      case SharedD_Button_Type.outlined:
        return OutlinedButton(
          onPressed: onPressedResolved,
          child: isLoading
              ? loadingChild(
                  color: theme.colorScheme.primary,
                )
              : Text(label),
        );
    }
  }
}
