import 'package:animation_kit/animation_kit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/widgets.dart';

void main() {
  group('AnimatedValueBuilder', () {
    testWidgets('should animate between initialValue and value', (
      tester,
    ) async {
      double initialValue = 0.0;
      double targetValue = 1.0;
      Duration duration = const Duration(seconds: 1);

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: AnimatedValueBuilder<double>(
            initialValue: initialValue,
            value: targetValue,
            duration: duration,
            builder: (context, value, child) {
              return Opacity(opacity: value, child: child);
            },
            child: const Text('Animated Text'),
          ),
        ),
      );

      // Verify initial state
      expect(find.text('Animated Text'), findsOneWidget);
      expect(
        tester.widget<Opacity>(find.byType(Opacity)).opacity,
        initialValue,
      );

      // Trigger animation
      await tester.pump(duration * 0.5);
      expect(
        tester.widget<Opacity>(find.byType(Opacity)).opacity,
        closeTo(0.5, 0.1),
      );

      // Complete animation
      await tester.pumpAndSettle();
      expect(tester.widget<Opacity>(find.byType(Opacity)).opacity, targetValue);
    });

    testWidgets('should call onEnd when animation completes', (tester) async {
      bool onEndCalled = false;
      double targetValue = 1.0;

      await tester.pumpWidget(
        AnimatedValueBuilder<double>(
          initialValue: 0.0,
          value: targetValue,
          duration: const Duration(seconds: 1),
          builder: (context, value, child) {
            return Opacity(opacity: value, child: child);
          },
          onEnd: (value) {
            onEndCalled = true;
          },
        ),
      );

      // Complete animation
      await tester.pumpAndSettle();
      expect(onEndCalled, isTrue);
    });

    testWidgets('should rebuild when value changes', (tester) async {
      double initialValue = 0.0;
      double targetValue = 1.0;

      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: AnimatedValueBuilder<double>(
            initialValue: initialValue,
            value: initialValue,
            duration: const Duration(seconds: 1),
            builder: (context, value, child) {
              return Opacity(opacity: value, child: child);
            },
            child: const Text('Animated Text'),
          ),
        ),
      );

      // Verify initial state
      expect(
        tester.widget<Opacity>(find.byType(Opacity)).opacity,
        initialValue,
      );

      // Update value
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: AnimatedValueBuilder<double>(
            initialValue: initialValue,
            value: targetValue,
            duration: const Duration(seconds: 1),
            builder: (context, value, child) {
              return Opacity(opacity: value, child: child);
            },
            child: const Text('Animated Text'),
          ),
        ),
      );

      // Trigger animation
      await tester.pump(const Duration(milliseconds: 500));
      expect(
        tester.widget<Opacity>(find.byType(Opacity)).opacity,
        closeTo(0.5, 0.1),
      );

      // Complete animation
      await tester.pumpAndSettle();
      expect(tester.widget<Opacity>(find.byType(Opacity)).opacity, targetValue);
    });
  });
}
