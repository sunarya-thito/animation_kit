import 'package:animation_kit/animation_kit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  group('Transformers', () {
    test('typeDouble interpolates correctly', () {
      expect(Transformers.typeDouble(0.0, 10.0, 0.5), 5.0);
      expect(Transformers.typeDouble(5.0, 15.0, 0.0), 5.0);
      expect(Transformers.typeDouble(5.0, 15.0, 1.0), 15.0);
      expect(Transformers.typeDouble(null, 10.0, 0.5), null);
      expect(Transformers.typeDouble(5.0, null, 0.5), null);
    });

    test('typeInt interpolates correctly', () {
      expect(Transformers.typeInt(0, 10, 0.5), 5);
      expect(Transformers.typeInt(5, 15, 0.0), 5);
      expect(Transformers.typeInt(5, 15, 1.0), 15);
      expect(Transformers.typeInt(null, 10, 0.5), null);
      expect(Transformers.typeInt(5, null, 0.5), null);
    });

    test('typeOffset interpolates correctly', () {
      expect(
        Transformers.typeOffset(const Offset(0, 0), const Offset(10, 10), 0.5),
        const Offset(5, 5),
      );
      expect(
        Transformers.typeOffset(const Offset(5, 5), const Offset(15, 15), 0.0),
        const Offset(5, 5),
      );
      expect(
        Transformers.typeOffset(const Offset(5, 5), const Offset(15, 15), 1.0),
        const Offset(15, 15),
      );
      expect(Transformers.typeOffset(null, const Offset(10, 10), 0.5), null);
      expect(Transformers.typeOffset(const Offset(5, 5), null, 0.5), null);
    });

    test('typeSize interpolates correctly', () {
      expect(
        Transformers.typeSize(const Size(0, 0), const Size(10, 10), 0.5),
        const Size(5, 5),
      );
      expect(
        Transformers.typeSize(const Size(5, 5), const Size(15, 15), 0.0),
        const Size(5, 5),
      );
      expect(
        Transformers.typeSize(const Size(5, 5), const Size(15, 15), 1.0),
        const Size(15, 15),
      );
      expect(Transformers.typeSize(null, const Size(10, 10), 0.5), null);
      expect(Transformers.typeSize(const Size(5, 5), null, 0.5), null);
    });
  });
}
