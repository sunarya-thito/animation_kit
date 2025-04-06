import 'package:flutter/widgets.dart';

/// A generic class that represents an animatable value between a start and an end value.
///
/// This class extends [Animatable] and provides a way to interpolate between
/// two values of type [T] using a custom linear interpolation function.
///
/// The [lerp] function is used to calculate the interpolated value based on
/// the given progress [t], which should be a value between 0.0 and 1.0.
///
/// Example usage:
/// ```dart
/// final animatable = AnimatableValue<double>(
///   start: 0.0,
///   end: 100.0,
///   lerp: (a, b, t) => a + (b - a) * t,
/// );
/// final valueAtHalfway = animatable.transform(0.5); // 50.0
/// ```
///
/// Type Parameters:
/// - [T]: The type of the animatable value.
///
/// Properties:
/// - [start]: The starting value of the animation.
/// - [end]: The ending value of the animation.
/// - [lerp]: A function that defines how to interpolate between [start] and [end].
///
/// Methods:
/// - [transform]: Returns the interpolated value at a given progress [t].
/// - [toString]: Returns a string representation of the animatable value.
/// - [operator ==]: Compares two [AnimatableValue] instances for equality.
/// - [hashCode]: Returns the hash code for the instance.
class AnimatableValue<T> extends Animatable<T> {
  /// The starting value of the animation.
  ///
  /// This represents the initial state or value from which the animation begins.
  final T start;

  /// The ending value of the animation.
  ///
  /// This represents the final state that the animation will reach
  /// when it completes.
  final T end;

  /// A function that interpolates between two values of type `T`.
  ///
  /// The function takes three parameters:
  /// - `a`: The starting value.
  /// - `b`: The ending value.
  /// - `t`: A double value between 0.0 and 1.0 representing the interpolation
  ///   factor, where 0.0 corresponds to `a` and 1.0 corresponds to `b`.
  ///
  /// Returns the interpolated value of type `T`.
  final T Function(T a, T b, double t) lerp;

  /// A class that represents an animatable value with a start and end value,
  /// and a function to interpolate between them.
  ///
  /// The `start` parameter specifies the initial value of the animation.
  /// The `end` parameter specifies the final value of the animation.
  /// The `lerp` parameter is a function that defines how to interpolate
  /// between the `start` and `end` values.
  AnimatableValue({required this.start, required this.end, required this.lerp});

  @override
  T transform(double t) {
    return lerp(start, end, t);
  }

  @override
  String toString() {
    return 'AnimatableValue($start, $end)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AnimatableValue &&
        other.start == start &&
        other.end == end &&
        other.lerp == lerp;
  }

  @override
  int get hashCode {
    return Object.hash(start, end, lerp);
  }
}

/// Extension on nullable interpolation functions to provide additional
/// functionality for working with nullable types in animations.
///
/// This extension allows you to define a custom interpolation function
/// (`lerp`) for nullable types (`T?`) that takes two nullable values (`a` and `b`)
/// and a double (`t`) representing the interpolation factor, and returns
/// the interpolated value.
///
/// Example usage:
/// ```dart
/// T? customLerp(T? a, T? b, double t) {
///   // Custom interpolation logic here
/// }
/// ```
///
/// This extension can be used to simplify working with animations
/// involving nullable values.
extension NullableLerpExtension<T> on T? Function(T? a, T? b, double t) {
  /// Linearly interpolates between two non-null values of type [T] based on the given
  /// interpolation factor [t].
  ///
  /// The parameter [a] represents the starting value, and [b] represents the ending value.
  /// The parameter [t] is a double value between 0.0 and 1.0, where 0.0 corresponds to [a]
  /// and 1.0 corresponds to [b]. Values of [t] outside this range will extrapolate the result.
  ///
  /// Returns a value of type [T] that is the result of the interpolation.
  T nonNullLerp(T a, T b, double t) {
    T? result = this(a, b, t);
    assert(result != null);
    return result!;
  }
}
