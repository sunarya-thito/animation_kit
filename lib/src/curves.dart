import 'package:flutter/widgets.dart';

/// A custom curve that allows for an interval-based animation with a specific duration.
///
/// This class extends the [Curve] class and can be used to define a custom animation
/// curve that operates within a specific interval of the animation timeline.
///
/// Example usage:
/// ```dart
/// AnimationController controller = AnimationController(
///   duration: const Duration(seconds: 2),
///   vsync: this,
/// );
///
/// Animation<double> animation = CurvedAnimation(
///   parent: controller,
///   curve: IntervalDuration(),
/// );
/// ```
///
/// This is useful for creating animations that only play during a specific portion
/// of the overall animation duration.
class IntervalDuration extends Curve {
  final Duration? start;
  final Duration? end;
  final Duration duration;
  final Curve? curve;

  /// Creates a curve interval with a specific duration.
  ///
  /// The [IntervalDuration] class is used to define a time interval
  /// for animations, specifying the start and end times as a fraction
  /// of the total animation duration.
  ///
  /// This is useful for creating complex animations where different
  /// parts of the animation occur at different times.
  const IntervalDuration({
    this.start,
    this.end,
    required this.duration,
    this.curve,
  });

  /// Creates an `IntervalDuration` with a delay.
  ///
  /// The `delayed` factory constructor allows you to specify a delay
  /// before the interval starts. This can be useful for creating
  /// animations that begin after a certain duration.
  ///
  /// Parameters:
  /// - [delay]: The duration to wait before the interval starts.
  /// - [duration]: The duration of the interval after the delay.
  ///
  /// Returns an instance of `IntervalDuration` with the specified delay
  /// and duration.
  factory IntervalDuration.delayed({
    Duration? startDelay,
    Duration? endDelay,
    required Duration duration,
  }) {
    if (startDelay != null) {
      duration += startDelay;
    }
    if (endDelay != null) {
      duration += endDelay;
    }
    return IntervalDuration(
      start: startDelay,
      end: endDelay != null ? duration - endDelay : null,
      duration: duration,
    );
  }

  @override
  double transform(double t) {
    double progressStartInterval;
    double progressEndInterval;
    if (start != null) {
      progressStartInterval = start!.inMicroseconds / duration.inMicroseconds;
    } else {
      progressStartInterval = 0;
    }
    if (end != null) {
      progressEndInterval = end!.inMicroseconds / duration.inMicroseconds;
    } else {
      progressEndInterval = 1;
    }
    double clampedProgress = ((t - progressStartInterval) /
            (progressEndInterval - progressStartInterval))
        .clamp(0, 1);
    if (curve != null) {
      return curve!.transform(clampedProgress);
    }
    return clampedProgress;
  }

  @override
  String toString() {
    return 'IntervalDuration(start: $start, end: $end, duration: $duration)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is IntervalDuration &&
        other.start == start &&
        other.end == end &&
        other.duration == duration &&
        other.curve == curve;
  }

  @override
  int get hashCode {
    return Object.hash(start, end, duration, curve);
  }
}
