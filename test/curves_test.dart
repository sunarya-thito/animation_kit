import 'package:flutter/animation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:animation_kit/src/curves.dart';

void main() {
  group('IntervalDuration', () {
    test('transform returns correct value within interval', () {
      const duration = Duration(seconds: 10);
      const interval = IntervalDuration(
        start: Duration(seconds: 2),
        end: Duration(seconds: 8),
        duration: duration,
      );

      expect(interval.transform(0.0), 0.0);
      expect(interval.transform(0.2), 0.0);
      expect(
        interval.transform(0.5),
        closeTo(0.5, 0.01),
      ); // due to percision error
      expect(interval.transform(0.8), 1.0);
      expect(interval.transform(1.0), 1.0);
    });

    test('transform applies curve if provided', () {
      const duration = Duration(seconds: 10);
      const interval = IntervalDuration(
        start: Duration(seconds: 2),
        end: Duration(seconds: 8),
        duration: duration,
        curve: Curves.easeIn,
      );

      final transformedValue = interval.transform(0.5);
      expect(transformedValue, greaterThan(0.0));
      expect(transformedValue, lessThan(1.0));
    });

    test('delayed factory constructor creates correct interval', () {
      const duration = Duration(seconds: 5);
      final interval = IntervalDuration.delayed(
        startDelay: Duration(seconds: 2),
        endDelay: Duration(seconds: 1),
        duration: duration,
      );

      expect(interval.start, Duration(seconds: 2));
      expect(interval.end, Duration(seconds: 7));
      expect(interval.duration, Duration(seconds: 8));
    });

    test('toString returns correct string representation', () {
      const interval = IntervalDuration(
        start: Duration(seconds: 2),
        end: Duration(seconds: 8),
        duration: Duration(seconds: 10),
      );

      expect(
        interval.toString(),
        'IntervalDuration(start: 0:00:02.000000, end: 0:00:08.000000, duration: 0:00:10.000000)',
      );
    });

    test('equality operator works correctly', () {
      const interval1 = IntervalDuration(
        start: Duration(seconds: 2),
        end: Duration(seconds: 8),
        duration: Duration(seconds: 10),
      );

      const interval2 = IntervalDuration(
        start: Duration(seconds: 2),
        end: Duration(seconds: 8),
        duration: Duration(seconds: 10),
      );

      const interval3 = IntervalDuration(
        start: Duration(seconds: 3),
        end: Duration(seconds: 7),
        duration: Duration(seconds: 10),
      );

      expect(interval1 == interval2, isTrue);
      expect(interval1 == interval3, isFalse);
    });

    test('hashCode works correctly', () {
      const interval1 = IntervalDuration(
        start: Duration(seconds: 2),
        end: Duration(seconds: 8),
        duration: Duration(seconds: 10),
      );

      const interval2 = IntervalDuration(
        start: Duration(seconds: 2),
        end: Duration(seconds: 8),
        duration: Duration(seconds: 10),
      );

      expect(interval1.hashCode, equals(interval2.hashCode));
    });
  });
}
