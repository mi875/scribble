import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scribble/scribble.dart';
import 'package:scribble/src/view/painting/scribble_editing_painter.dart';
import 'package:scribble/src/view/painting/scribble_painter.dart';

void main() {
  setUp(() {});

  group('Scribble', () {
    group('fixedStrokeWidth', () {
      Widget build({double? fixedStrokeWidth}) {
        return MaterialApp(
          home: Scribble(
            notifier: ScribbleNotifier(),
            fixedStrokeWidth: fixedStrokeWidth,
          ),
        );
      }

      testWidgets(
        'sets fixedStrokeWidth on ScribbleEditingPainter',
        (WidgetTester tester) async {
          await tester.pumpWidget(build(fixedStrokeWidth: 10));
          final finder = find.byType(CustomPaint);
          final widgets =
              finder.evaluate().map((e) => e.widget).cast<CustomPaint>();
          final painters = widgets.map((e) => e.foregroundPainter).toList();
          final painter = painters.whereType<ScribbleEditingPainter>().first;
          expect(painter.fixedStrokeWidth, equals(10));
        },
      );

      testWidgets(
        'sets fixedStrokeWidth on ScribblePainter',
        (WidgetTester tester) async {
          await tester.pumpWidget(build(fixedStrokeWidth: 10));
          final finder = find.byType(CustomPaint);
          final widgets =
              finder.evaluate().map((e) => e.widget).cast<CustomPaint>();
          final painters = widgets.map((e) => e.painter).toList();
          final painter = painters.whereType<ScribblePainter>().first;
          expect(painter.fixedStrokeWidth, equals(10));
        },
      );
    });
  });
}
