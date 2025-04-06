import 'dart:ui';

/// A utility class that provides static methods for transforming
/// various types of values, such as numbers, colors, offsets,
/// and sizes.
abstract class Transformers {
  const Transformers._();

  /// Interpolates between two double values [a] and [b] based on the given
  /// interpolation factor [t].
  ///
  /// The parameter [t] should be a value between 0.0 and 1.0, where:
  /// - 0.0 corresponds to [a],
  /// - 1.0 corresponds to [b],
  /// - values in between represent a linear interpolation.
  ///
  /// If either [a] or [b] is `null`, the result will also be `null`.
  ///
  /// Returns the interpolated double value or `null` if either input is `null`.
  static double? typeDouble(double? a, double? b, double t) {
    if (a == null || b == null) {
      return null;
    }
    return a + (b - a) * t;
  }

  /// Interpolates between two integer values [a] and [b] based on the given
  /// factor [t].
  ///
  /// The parameter [t] is a double value typically between 0.0 and 1.0,
  /// where 0.0 corresponds to [a] and 1.0 corresponds to [b]. If [t] is
  /// outside this range, the interpolation will still compute a value
  /// accordingly.
  ///
  /// Returns the interpolated integer value, or `null` if both [a] and [b]
  /// are `null`. If only one of [a] or [b] is `null`, the non-null value
  /// is returned.
  static int? typeInt(int? a, int? b, double t) {
    if (a == null || b == null) {
      return null;
    }
    return (a + (b - a) * t).round();
  }

  /// Interpolates between two colors [a] and [b] based on the given factor [t].
  ///
  /// The parameter [t] is a double value between 0.0 and 1.0, where:
  /// - 0.0 corresponds to the color [a].
  /// - 1.0 corresponds to the color [b].
  ///
  /// If either [a] or [b] is null, the result will also be null.
  ///
  /// Returns the interpolated color or null if input colors are null.
  static Color? typeColor(Color? a, Color? b, double t) {
    if (a == null || b == null) {
      return null;
    }
    return Color.lerp(a, b, t);
  }

  /// Interpolates between two [Offset] values, [a] and [b], based on the given
  /// interpolation factor [t].
  ///
  /// The parameter [t] is a double value typically in the range of 0.0 to 1.0,
  /// where 0.0 corresponds to [a], 1.0 corresponds to [b], and values in between
  /// produce a weighted interpolation.
  ///
  /// If either [a] or [b] is `null`, the result will also be `null`.
  ///
  /// - [a]: The starting [Offset] value.
  /// - [b]: The ending [Offset] value.
  /// - [t]: The interpolation factor, where 0.0 represents [a] and 1.0 represents [b].
  ///
  /// Returns the interpolated [Offset] or `null` if either [a] or [b] is `null`.
  static Offset? typeOffset(Offset? a, Offset? b, double t) {
    if (a == null || b == null) {
      return null;
    }
    return Offset(typeDouble(a.dx, b.dx, t)!, typeDouble(a.dy, b.dy, t)!);
  }

  /// Interpolates between two [Size] objects, [a] and [b], based on the given
  /// interpolation factor [t].
  ///
  /// The parameter [t] is a value between 0.0 and 1.0, where:
  /// - 0.0 corresponds to [a],
  /// - 1.0 corresponds to [b],
  /// - Values in between represent a linear interpolation between [a] and [b].
  ///
  /// Returns the interpolated [Size] or `null` if both [a] and [b] are `null`.
  /// If one of [a] or [b] is `null`, the non-null value is returned.
  static Size? typeSize(Size? a, Size? b, double t) {
    if (a == null || b == null) {
      return null;
    }
    return Size(
      typeDouble(a.width, b.width, t)!,
      typeDouble(a.height, b.height, t)!,
    );
  }
}
