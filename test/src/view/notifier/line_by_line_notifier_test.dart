import 'package:flutter_test/flutter_test.dart';
import 'package:scribble/scribble.dart';

void main() {
  group('LineByLineNotifier', () {
    late LineByLineNotifier notifier;

    setUp(() {
      notifier = LineByLineNotifier();
    });

    group('deleteFreeDrawingSpace', () {
      testWidgets('removes strokes within deleted free space', (tester) async {
        // Create a free drawing space from Y 100 to Y 200 (height 100)
        notifier.insertFreeDrawingSpace(100.0, height: 100.0);

        // Add strokes: one within the free space, one above, one below
        final strokeInFreeSpace = SketchLine(
          points: [
            const Point(50, 150), // Within free space (Y 100-200)
            const Point(100, 150),
          ],
          color: 0xFF000000,
          width: 2.0,
        );

        final strokeAboveFreeSpace = SketchLine(
          points: [
            const Point(50, 50), // Above free space (Y < 100)
            const Point(100, 50),
          ],
          color: 0xFF000000,
          width: 2.0,
        );

        final strokeBelowFreeSpace = SketchLine(
          points: [
            const Point(50, 250), // Below free space (Y > 200)
            const Point(100, 250),
          ],
          color: 0xFF000000,
          width: 2.0,
        );

        // Add all strokes to the sketch
        final sketchWithStrokes = Sketch(lines: [
          strokeInFreeSpace,
          strokeAboveFreeSpace,
          strokeBelowFreeSpace,
        ]);

        notifier.setSketch(sketch: sketchWithStrokes, addToUndoHistory: false);

        // Verify initial state
        expect(notifier.value.sketch.lines.length, 3);

        // Delete the free drawing space
        notifier.deleteFreeDrawingSpace(150.0);

        // Verify that only the stroke within the free space was removed
        expect(notifier.value.sketch.lines.length, 2);

        // The remaining strokes should be the ones above and below (shifted up)
        final remainingLines = notifier.value.sketch.lines;

        // Find the stroke that was originally above (should remain at Y 50)
        final aboveStroke = remainingLines.firstWhere(
          (line) => line.points.first.y == 50,
        );
        expect(aboveStroke.points.first.x, 50);

        // Find the stroke that was originally below (should be shifted up by 100)
        final belowStroke = remainingLines.firstWhere(
          (line) => line.points.first.y == 150, // 250 - 100 = 150
        );
        expect(belowStroke.points.first.x, 50);
      });

      testWidgets('removes strokes partially within deleted free space', (tester) async {
        // Create a free drawing space from Y 100 to Y 200
        notifier.insertFreeDrawingSpace(100.0, height: 100.0);

        // Add a stroke that partially overlaps the free space
        final partiallyOverlappingStroke = SketchLine(
          points: [
            const Point(50, 80),  // Above free space
            const Point(75, 120), // Within free space
            const Point(100, 160), // Within free space
          ],
          color: 0xFF000000,
          width: 2.0,
        );

        final completelyOutsideStroke = SketchLine(
          points: [
            const Point(50, 50),
            const Point(100, 60),
          ],
          color: 0xFF000000,
          width: 2.0,
        );

        // Add strokes to the sketch
        final sketchWithStrokes = Sketch(lines: [
          partiallyOverlappingStroke,
          completelyOutsideStroke,
        ]);

        notifier.setSketch(sketch: sketchWithStrokes, addToUndoHistory: false);

        // Verify initial state
        expect(notifier.value.sketch.lines.length, 2);

        // Delete the free drawing space
        notifier.deleteFreeDrawingSpace(150.0);

        // Verify that the partially overlapping stroke was removed
        expect(notifier.value.sketch.lines.length, 1);

        // The remaining stroke should be the completely outside one
        final remainingStroke = notifier.value.sketch.lines.first;
        expect(remainingStroke.points.first.y, 50);
        expect(remainingStroke.points.last.y, 60);
      });

      testWidgets('preserves strokes completely outside deleted free space', (tester) async {
        // Create a free drawing space from Y 100 to Y 200
        notifier.insertFreeDrawingSpace(100.0, height: 100.0);

        // Add strokes completely outside the free space
        final strokeAbove = SketchLine(
          points: [
            const Point(50, 50),
            const Point(100, 60),
          ],
          color: 0xFF000000,
          width: 2.0,
        );

        final strokeBelow = SketchLine(
          points: [
            const Point(50, 250),
            const Point(100, 260),
          ],
          color: 0xFF000000,
          width: 2.0,
        );

        // Add strokes to the sketch
        final sketchWithStrokes = Sketch(lines: [strokeAbove, strokeBelow]);
        notifier.setSketch(sketch: sketchWithStrokes, addToUndoHistory: false);

        // Verify initial state
        expect(notifier.value.sketch.lines.length, 2);

        // Delete the free drawing space
        notifier.deleteFreeDrawingSpace(150.0);

        // Verify that both strokes are preserved
        expect(notifier.value.sketch.lines.length, 2);

        // Verify stroke positions: above should remain, below should shift up
        final lines = notifier.value.sketch.lines;
        
        // Find stroke that was above (unchanged position)
        final aboveStroke = lines.firstWhere((line) => line.points.first.y == 50);
        expect(aboveStroke.points.last.y, 60);

        // Find stroke that was below (shifted up by 100)
        final belowStroke = lines.firstWhere((line) => line.points.first.y == 150);
        expect(belowStroke.points.last.y, 160); // 260 - 100 = 160
      });

      testWidgets('handles undo/redo correctly after stroke removal', (tester) async {
        // Create a free drawing space
        notifier.insertFreeDrawingSpace(100.0, height: 100.0);

        // Add a stroke within the free space
        final strokeInFreeSpace = SketchLine(
          points: [const Point(50, 150)],
          color: 0xFF000000,
          width: 2.0,
        );

        final sketchWithStroke = Sketch(lines: [strokeInFreeSpace]);
        notifier.setSketch(sketch: sketchWithStroke, addToUndoHistory: true);

        // Verify initial state
        expect(notifier.value.sketch.lines.length, 1);

        // Delete the free drawing space (this should add to undo history)
        notifier.deleteFreeDrawingSpace(150.0);

        // Verify stroke was removed
        expect(notifier.value.sketch.lines.length, 0);

        // Undo the deletion - this should restore both the space and the stroke
        notifier.undo();

        // Verify the stroke is back
        expect(notifier.value.sketch.lines.length, 1);
        expect(notifier.value.sketch.lines.first.points.first.y, 150);

        // Redo the deletion
        notifier.redo();

        // Verify stroke is removed again
        expect(notifier.value.sketch.lines.length, 0);
      });

      testWidgets('throws error when no free space found at position', (tester) async {
        // Try to delete a free space at a position where none exists
        expect(
          () => notifier.deleteFreeDrawingSpace(100.0),
          throwsA(isA<StateError>()),
        );
      });
    });
  });
}