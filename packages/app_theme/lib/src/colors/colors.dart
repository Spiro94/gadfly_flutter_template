import 'package:app_theme/src/colors/variations.dart';
import 'package:equatable/equatable.dart';

/// {@template appTheme.colors}
/// The complete set of [AppColorVariations].
/// {@endtemplate}
class AppColors extends Equatable {
  /// {@macro appTheme.colors}
  const AppColors({
    required this.primary,
    required this.secondary,
    required this.success,
    required this.error,
    required this.info,
    required this.warning,
    required this.neutral,
  });

  /// This color set is the primary accent
  final AppColorVariations primary;

  /// This color set is the secondary accent
  final AppColorVariations secondary;

  /// This color set is used to indicate a success
  final AppColorVariations success;

  /// This color set is used to indicate an error
  final AppColorVariations error;

  /// This color set is used to indicate information
  final AppColorVariations info;

  /// This color set is used to warnings
  final AppColorVariations warning;

  /// This color set is used for texture and is considered to have neutral
  /// semantic meaning
  final AppColorVariations neutral;

  /// Linear interpolation of [AppColors]
  AppColors lerp(AppColors? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      primary: primary.lerp(other.primary, t),
      secondary: secondary.lerp(other.secondary, t),
      success: success.lerp(other.success, t),
      error: error.lerp(other.error, t),
      info: info.lerp(other.info, t),
      warning: warning.lerp(other.warning, t),
      neutral: neutral.lerp(other.neutral, t),
    );
  }

  @override
  List<Object?> get props => [
        primary,
        secondary,
        success,
        error,
        info,
        warning,
        neutral,
      ];
}
