import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// {@template appTheme.colorVariations}
/// The color variations range from none to all. These names are meant to be
/// agnostic to whether you are using light or dark mode.
/// {@endtemplate}
class AppColorVariations extends Equatable {
  /// {@macro appTheme.colorVariations}
  const AppColorVariations({
    required this.none,
    required this.nearNone,
    required this.lowest,
    required this.lower,
    required this.low,
    required this.midLow,
    required this.mid,
    required this.midHigh,
    required this.high,
    required this.higher,
    required this.highest,
    required this.all,
  });

  /// white / black
  final Color none;

  /// 50
  final Color nearNone;

  /// 100
  final Color lowest;

  /// 200
  final Color lower;

  /// 300
  final Color low;

  /// 400
  final Color midLow;

  /// 500
  final Color mid;

  /// 600
  final Color midHigh;

  /// 700
  final Color high;

  /// 800
  final Color higher;

  /// 900
  final Color highest;

  /// black / white
  final Color all;

  /// linear interpolation of [AppColorVariations]
  AppColorVariations lerp(AppColorVariations? other, double t) {
    if (other is! AppColorVariations) return this;
    return AppColorVariations(
      none: Color.lerp(none, other.none, t)!,
      nearNone: Color.lerp(nearNone, other.nearNone, t)!,
      lowest: Color.lerp(lowest, other.lowest, t)!,
      lower: Color.lerp(lower, other.lower, t)!,
      low: Color.lerp(low, other.low, t)!,
      midLow: Color.lerp(midLow, other.midLow, t)!,
      mid: Color.lerp(mid, other.mid, t)!,
      midHigh: Color.lerp(midHigh, other.midHigh, t)!,
      high: Color.lerp(high, other.high, t)!,
      higher: Color.lerp(higher, other.higher, t)!,
      highest: Color.lerp(highest, other.highest, t)!,
      all: Color.lerp(all, other.all, t)!,
    );
  }

  @override
  List<Object?> get props => [
        none,
        nearNone,
        lowest,
        lower,
        low,
        midLow,
        mid,
        midHigh,
        high,
        higher,
        highest,
        all,
      ];
}
