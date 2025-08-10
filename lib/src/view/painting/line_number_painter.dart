import 'package:flutter/material.dart';

/// A custom painter that draws line numbers on the left margin of notebook pages.
///
/// This painter renders sequential line numbers in a vertical column on the left side.
class LineNumberPainter extends CustomPainter {
  /// Creates a new line number painter.
  const LineNumberPainter({
    required this.paperWidth,
    required this.paperHeight,
    required this.textColor,
    required this.fontSize,
    this.leftMargin = 0.0,
    this.topMargin = 0.0,
    this.bottomMargin = 0.0,
    this.numberWidth = 40.0,
    this.startLineNumber = 1,
    this.rowLineSpacing,
  });

  /// Width of the paper in logical pixels.
  final double paperWidth;

  /// Height of the paper in logical pixels.
  final double paperHeight;

  /// Color of the line numbers.
  final Color textColor;

  /// Font size for the line numbers.
  final double fontSize;

  /// Left margin where numbers should start.
  final double leftMargin;

  /// Top margin where numbers should not be drawn.
  final double topMargin;

  /// Bottom margin where numbers should not be drawn.
  final double bottomMargin;

  /// Width allocated for line numbers.
  final double numberWidth;

  /// Starting line number (usually 1).
  final int startLineNumber;

  /// Spacing between row lines (if available) to synchronize numbering.
  final double? rowLineSpacing;

  @override
  void paint(Canvas canvas, Size size) {
    // Set up text style
    final textStyle = TextStyle(
      color: textColor,
      fontSize: fontSize,
      fontFamily: 'monospace',
      fontWeight: FontWeight.w400,
    );

    // Calculate the drawing area height for line numbers
    final drawingTop = topMargin;
    final drawingBottom = paperHeight - bottomMargin;
    final availableHeight = drawingBottom - drawingTop;

    // Don't draw if margins make drawing area invalid
    if (drawingTop >= drawingBottom || availableHeight <= 0) return;

    // Use row line spacing if available, otherwise use default spacing
    final lineSpacing = rowLineSpacing ?? 32.0;
    final maxLines = (availableHeight / lineSpacing).floor();

    // Draw all line numbers between the row lines
    for (num i = 0; i < maxLines; i++) {
      final currentLine = startLineNumber + i;
      // Position number between current and next row line
      final betweenRowsY = drawingTop + (i * lineSpacing) + (lineSpacing / 2);

      // Don't draw numbers beyond the bottom margin
      if (betweenRowsY > drawingBottom) break;

      // Create text painter for the line number
      final textPainter = TextPainter(
        text: TextSpan(text: currentLine.toString(), style: textStyle),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout(maxWidth: numberWidth - 4);

      // Position number in the left margin, right-aligned with some padding
      final textX = leftMargin + numberWidth - textPainter.width - 4;
      // Center the text vertically between row lines
      final textY = betweenRowsY - (textPainter.height / 2);

      // Draw the line number
      textPainter.paint(canvas, Offset(textX, textY));
    }
  }

  @override
  bool shouldRepaint(LineNumberPainter oldDelegate) {
    return paperWidth != oldDelegate.paperWidth ||
        paperHeight != oldDelegate.paperHeight ||
        textColor != oldDelegate.textColor ||
        fontSize != oldDelegate.fontSize ||
        leftMargin != oldDelegate.leftMargin ||
        topMargin != oldDelegate.topMargin ||
        bottomMargin != oldDelegate.bottomMargin ||
        numberWidth != oldDelegate.numberWidth ||
        startLineNumber != oldDelegate.startLineNumber ||
        rowLineSpacing != oldDelegate.rowLineSpacing;
  }
}
