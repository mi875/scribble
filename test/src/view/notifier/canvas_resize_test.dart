import 'package:flutter_test/flutter_test.dart';
import 'package:scribble/src/view/notifier/line_by_line_notifier.dart';

void main() {
  group('Canvas Resizing with Image Rows', () {
    late LineByLineNotifier notifier;

    setUp(() {
      notifier = LineByLineNotifier(
        initialCanvasHeight: 500,
      );
    });

    tearDown(() {
      notifier.dispose();
    });

    test('canvas should extend when image row is added below current content', () {
      // Initial canvas height should be 500
      expect(notifier.canvasHeight, equals(500));

      // Add an image row at position 400 with height 150
      // This should push the content to position 550 (400 + 150)
      notifier.insertImageRowWithBytes(
        400,
        [1, 2, 3], // Dummy image bytes
        height: 150,
      );

      // Canvas should have extended to accommodate the image row
      // Expected: at least 550 + margin
      expect(notifier.canvasHeight, greaterThan(550));
    });

    test('canvas should extend when multiple image rows are added', () {
      final initialHeight = notifier.canvasHeight;

      // Add first image row
      notifier.insertImageRowWithBytes(
        200,
        [1, 2, 3],
        height: 100,
      );

      // Add second image row (will be shifted down due to first one)
      notifier.insertImageRowWithBytes(
        350,
        [4, 5, 6],
        height: 80,
      );

      // Canvas should have extended to accommodate both image rows
      expect(notifier.canvasHeight, greaterThan(initialHeight));
      
      // Verify image rows are properly indexed
      expect(notifier.imageRows.length, equals(2));
      expect(notifier.imageRows[0].rendererIndex, equals(0));
      expect(notifier.imageRows[0].visualIndex, equals(1));
      expect(notifier.imageRows[1].rendererIndex, equals(1));
      expect(notifier.imageRows[1].visualIndex, equals(2));
    });

    test('canvas should shrink when image row is deleted', () {
      // Add an image row at the bottom
      notifier.insertImageRowWithBytes(
        400,
        [1, 2, 3],
        height: 200,
      );

      final heightWithImageRow = notifier.canvasHeight;
      expect(heightWithImageRow, greaterThan(600));

      // Delete the image row
      notifier.deleteImageRow(450); // Y position within the image row

      // Canvas should shrink back closer to initial height
      expect(notifier.canvasHeight, lessThan(heightWithImageRow));
    });

    test('canvas should consider image row end position in max content calculation', () {
      // Add an image row
      notifier.insertImageRowWithBytes(
        300,
        [1, 2, 3],
        height: 250, // This will make the image row end at Y=550
      );

      // The canvas height should be at least 550 plus some buffer
      // (The _getRequiredRows adds 2 extra rows as buffer)
      expect(notifier.canvasHeight, greaterThan(550));
    });

    test('canvas should handle free drawing spaces along with image rows', () {
      // Add a free drawing space
      notifier.insertFreeDrawingSpace(200, height: 100);

      // Add an image row after the free drawing space
      notifier.insertImageRowWithBytes(
        350, // This will be shifted to 450 due to free space
        [1, 2, 3],
        height: 150,
      );

      // Canvas should accommodate both the free space and image row
      // Free space ends at 300, image row will be shifted and end at 600
      expect(notifier.canvasHeight, greaterThan(600));
    });
  });
}