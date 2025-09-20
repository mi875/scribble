import 'package:flutter_test/flutter_test.dart';
import 'package:scribble/src/domain/model/image_row/image_row.dart';

void main() {
  group('ImageRow', () {
    test('should create image row with default indices', () {
      final imageRow = ImageRow(
        startY: 100,
        height: 50,
      );

      expect(imageRow.rendererIndex, equals(0));
      expect(imageRow.visualIndex, equals(1));
      expect(imageRow.startY, equals(100));
      expect(imageRow.height, equals(50));
      expect(imageRow.endY, equals(150));
    });

    test('should create image row with custom indices', () {
      final imageRow = ImageRow(
        startY: 200,
        height: 75,
        rendererIndex: 3,
        visualIndex: 4,
        id: 'test-row',
      );

      expect(imageRow.rendererIndex, equals(3));
      expect(imageRow.visualIndex, equals(4));
      expect(imageRow.id, equals('test-row'));
    });

    test('should update renderer index correctly', () {
      const imageRow = ImageRow(
        startY: 100,
        height: 50,
      );

      final updated = imageRow.withRendererIndex(5);

      expect(updated.rendererIndex, equals(5));
      expect(updated.visualIndex, equals(1)); // Should remain unchanged
      expect(updated.startY, equals(100)); // Should remain unchanged
    });

    test('should update visual index correctly', () {
      const imageRow = ImageRow(
        startY: 100,
        height: 50,
      );

      final updated = imageRow.withVisualIndex(3);

      expect(updated.visualIndex, equals(3));
      expect(updated.rendererIndex, equals(0)); // Should remain unchanged
      expect(updated.startY, equals(100)); // Should remain unchanged
    });

    test('should update both indices correctly', () {
      const imageRow = ImageRow(
        startY: 100,
        height: 50,
      );

      final updated = imageRow.withIndices(
        rendererIndex: 7,
        visualIndex: 8,
      );

      expect(updated.rendererIndex, equals(7));
      expect(updated.visualIndex, equals(8));
      expect(updated.startY, equals(100)); // Should remain unchanged
    });

    test('should correctly check if Y position is contained', () {
      const imageRow = ImageRow(
        startY: 100,
        height: 50,
      );

      expect(imageRow.containsY(99), isFalse);
      expect(imageRow.containsY(100), isTrue);
      expect(imageRow.containsY(125), isTrue);
      expect(imageRow.containsY(150), isTrue);
      expect(imageRow.containsY(151), isFalse);
    });

    test('should move image row by offset correctly', () {
      const imageRow = ImageRow(
        startY: 100,
        height: 50,
        rendererIndex: 2,
        visualIndex: 3,
      );

      final moved = imageRow.moveBy(25);

      expect(moved.startY, equals(125));
      expect(moved.endY, equals(175));
      expect(moved.height, equals(50)); // Should remain unchanged
      expect(moved.rendererIndex, equals(2)); // Should remain unchanged
      expect(moved.visualIndex, equals(3)); // Should remain unchanged
    });
  });
}