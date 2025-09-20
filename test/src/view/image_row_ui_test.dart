import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scribble/src/view/line_by_line_canvas.dart';
import 'package:scribble/src/view/notifier/line_by_line_notifier.dart';

void main() {
  group('Image Row UI Behavior', () {
    late LineByLineNotifier notifier;

    setUp(() {
      notifier = LineByLineNotifier(
        initialCanvasHeight: 300,
      );
    });

    tearDown(() {
      notifier.dispose();
    });

    testWidgets('image rows should display icons without popup menus', (tester) async {
      // Add an image row
      notifier.insertImageRowWithBytes(
        100,
        [1, 2, 3], // Dummy image bytes
        height: 50,
      );

      // Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LineByLineCanvas(
              notifier: notifier,
            ),
          ),
        ),
      );
      
      await tester.pumpAndSettle();

      // Should find image icons
      expect(find.byIcon(Icons.image), findsAtLeastNWidgets(1));
      
      // Should not find any PopupMenuButton for image rows
      // (PopupMenuButton should only exist for text rows and free spaces)
      
      // There might be popup buttons for text rows, but we need to verify
      // that tapping on the image icon area doesn't show a popup menu
      final imageIcon = find.byIcon(Icons.image).first;
      
      // Try to tap on the image icon
      await tester.tap(imageIcon);
      await tester.pumpAndSettle();
      
      // Should not show popup menu items related to image rows
      expect(find.text('画像行を削除'), findsNothing);
      expect(find.text('画像行を挿入'), findsNothing);
    });

    testWidgets('text rows should still have popup menus', (tester) async {
      // Build the widget with just text rows (no image rows)
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LineByLineCanvas(
              notifier: notifier,
            ),
          ),
        ),
      );
      
      await tester.pumpAndSettle();

      // Should find PopupMenuButton widgets for text rows
      expect(find.byType(PopupMenuButton<String>), findsAtLeastNWidgets(1));
      
      // Find a line number button (should be text, not an icon)
      final lineNumberButtons = find.byType(PopupMenuButton<String>);
      expect(lineNumberButtons, findsWidgets);
      
      // Tap on first line number button to open popup menu
      await tester.tap(lineNumberButtons.first);
      await tester.pumpAndSettle();
      
      // Should show standard row actions
      expect(find.text('上に行を挿入'), findsOneWidget);
      expect(find.text('フリー描画スペースを追加'), findsOneWidget);
      expect(find.text('行をクリア'), findsOneWidget);
      expect(find.text('行を削除'), findsOneWidget);
      
      // Should NOT show image row actions
      expect(find.text('画像行を削除'), findsNothing);
      expect(find.text('画像行を挿入'), findsNothing);
    });

    testWidgets('free drawing spaces should still have popup menus', (tester) async {
      // Add a free drawing space
      notifier.insertFreeDrawingSpace(150, height: 80);

      // Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LineByLineCanvas(
              notifier: notifier,
            ),
          ),
        ),
      );
      
      await tester.pumpAndSettle();

      // Should find space_bar icons for free spaces
      expect(find.byIcon(Icons.space_bar), findsAtLeastNWidgets(1));
      
      // Should find PopupMenuButton widgets
      final popupButtons = find.byType(PopupMenuButton<String>);
      expect(popupButtons, findsWidgets);
      
      // Find and tap a popup button that should correspond to the free space
      // (This is tricky to test precisely, but we can verify the menu content)
      await tester.tap(popupButtons.first);
      await tester.pumpAndSettle();
      
      // Should show free space actions or general actions
      expect(find.text('フリー描画スペースを追加'), findsOneWidget);
      
      // Should NOT show image row actions  
      expect(find.text('画像行を削除'), findsNothing);
      expect(find.text('画像行を挿入'), findsNothing);
    });
  });
}