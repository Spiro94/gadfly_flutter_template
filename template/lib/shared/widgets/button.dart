// coverage:ignore-file

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sprung/sprung.dart';

import '../../theme/theme.dart';

/// The types of [Shared_Button]s
enum Shared_ButtonType {
  /// This button is a primary action.
  ///
  /// Its appearance will be a [FilledButton] with a black background.
  primary,

  /// This button is a secondary action.
  ///
  /// Its appearance will be a [FilledButton] with a blue background.
  secondary,

  /// This button is a tertiary action.
  ///
  /// Its appearance will be an [OutlinedButton] with a white background.
  outlined,

  /// This is a text button.
  ///
  /// Its appearance will be a [TextButton] with a white background.
  text,

  /// This is a button indicating danger.
  /// E.g. when a user is confirming a deletion.
  ///
  /// Its appearance will be a [FilledButton]
  danger,
}

/// The status of the [Shared_Button]
enum Shared_ButtonStatus {
  /// This is when the button can be pressed
  enabled,

  /// This is when the button has been pressed and its action is processing.
  loading,

  /// This is when the button is disabled
  disabled,
}

/// A button widget with a type of [Shared_ButtonType].
class Shared_Button extends StatelessWidget {
  const Shared_Button({
    required this.buttonType,
    required this.status,
    required this.child,
    required this.onPressed,
    super.key,
  });

  /// The type of button
  final Shared_ButtonType buttonType;

  /// The current status of the button
  final Shared_ButtonStatus status;

  /// The button's child.
  final Widget child;

  /// The onPressed callback.
  ///
  /// Note: this deviates from Flutter's onPressed API. They overload
  /// `onPressed` and if the value is `null`, then the button is disabled. We
  /// don't find that API to be ergonomic, so instead, we will use
  /// [Shared_ButtonStatus.disabled] to indicate the button is disabled. So
  /// that means, you will always pass in an [onPressed] callback.
  final VoidCallback onPressed;

  /// - For the [Shared_ButtonStatus.enabled], we want the [onPressed] to fire
  ///   and we want our button to appear enabled.
  /// - For the [Shared_ButtonStatus.loading], we do not want the [onPressed]
  ///   to fire, but we do want our button to appear enabled. To achieve this,
  ///   we pass in an empty callback.
  /// - For the [Shared_ButtonStatus.disabled], we do not want the [onPressed]
  ///   to fire and we don't want out button to appear enabled. To achieve this,
  ///   we return `null`.
  VoidCallback? get _effectiveOnPressed {
    switch (status) {
      case Shared_ButtonStatus.enabled:
        return onPressed;
      case Shared_ButtonStatus.loading:
        return () {};
      case Shared_ButtonStatus.disabled:
        return null;
    }
  }

  Widget _effectiveChild({required BuildContext context}) {
    final color = context.tokens.color;

    switch (status) {
      case Shared_ButtonStatus.enabled:
      case Shared_ButtonStatus.disabled:
        return child;
      case Shared_ButtonStatus.loading:
        late Color spinnerColor;
        switch (buttonType) {
          case Shared_ButtonType.primary:
            spinnerColor = color.primary.onColor;
          case Shared_ButtonType.secondary:
            spinnerColor = color.secondary.container;
          case Shared_ButtonType.danger:
            spinnerColor = color.error.onColor;
          case Shared_ButtonType.outlined:
            spinnerColor = color.neutral.onBackground;
          case Shared_ButtonType.text:
            spinnerColor = color.secondary.color;
        }
        return SizedBox(
          width: 80,
          height: 8,
          child: SpinKitThreeBounce(
            color: spinnerColor,
          ),
        );
    }
  }

  Widget _childWrapper({required BuildContext context}) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Sprung.custom(
        mass: 1,
        stiffness: 100,
        damping: 20,
      ),
      child: _effectiveChild(context: context),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = context.tokens.color;

    switch (buttonType) {
      case Shared_ButtonType.primary:
        return FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: color.primary.color,
            foregroundColor: color.primary.onColor,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          onPressed: _effectiveOnPressed,
          child: _childWrapper(context: context),
        );
      case Shared_ButtonType.secondary:
        return FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: color.secondary.container,
            foregroundColor: color.secondary.onContainer,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          onPressed: _effectiveOnPressed,
          child: _childWrapper(context: context),
        );
      case Shared_ButtonType.outlined:
        return OutlinedButton(
          style: OutlinedButton.styleFrom(
            backgroundColor: color.neutral.background,
            foregroundColor: color.neutral.onBackground,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          onPressed: _effectiveOnPressed,
          child: _childWrapper(context: context),
        );
      case Shared_ButtonType.text:
        return TextButton(
          style: TextButton.styleFrom(
            backgroundColor: color.neutral.background,
            foregroundColor: color.secondary.color,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          onPressed: _effectiveOnPressed,
          child: _childWrapper(context: context),
        );
      case Shared_ButtonType.danger:
        return FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: color.error.color,
            foregroundColor: color.error.onColor,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          onPressed: _effectiveOnPressed,
          child: _childWrapper(context: context),
        );
    }
  }
}
