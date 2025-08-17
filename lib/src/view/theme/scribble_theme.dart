import 'package:flutter/material.dart';

/// Theme configuration for Scribble components, defining colors for
/// light and dark mode support.
@immutable
class ScribbleTheme {
  /// Creates a [ScribbleTheme] with the specified colors.
  const ScribbleTheme({
    required this.paperColor,
    required this.paperBorderColor,
    required this.paperShadowColor,
    required this.rowLineColor,
    required this.lineNumberColor,
    required this.controlBackgroundColor,
    required this.controlBorderColor,
    required this.controlIconColor,
    required this.eraserPointerColor,
  });

  /// Background color for the drawing paper/canvas.
  final Color paperColor;

  /// Border color around the paper/canvas.
  final Color paperBorderColor;

  /// Shadow color for paper elevation effect.
  final Color paperShadowColor;

  /// Color for row lines on lined paper.
  final Color rowLineColor;

  /// Color for line numbers on the paper.
  final Color lineNumberColor;

  /// Background color for UI controls (zoom controls, etc.).
  final Color controlBackgroundColor;

  /// Border color for UI controls.
  final Color controlBorderColor;

  /// Icon color for UI controls.
  final Color controlIconColor;

  /// Color for the eraser pointer indicator.
  final Color eraserPointerColor;

  /// Default light theme with bright colors suitable for light backgrounds.
  static const ScribbleTheme light = ScribbleTheme(
    paperColor: Colors.white,
    paperBorderColor: Color(0xFFE0E0E0),
    paperShadowColor: Color(0x1A000000),
    rowLineColor: Color(0xFFE0E0E0),
    lineNumberColor: Color(0xFFBDBDBD),
    controlBackgroundColor: Colors.white,
    controlBorderColor: Color(0xFFE0E0E0),
    controlIconColor: Color(0xFF757575),
    eraserPointerColor: Colors.black,
  );

  /// Default dark theme with muted colors suitable for dark backgrounds.
  static const ScribbleTheme dark = ScribbleTheme(
    paperColor: Color(0xFF1E1E1E),
    paperBorderColor: Color(0xFF404040),
    paperShadowColor: Color(0x40000000),
    rowLineColor: Color(0xFF4A5568),
    lineNumberColor: Color(0xFF718096),
    controlBackgroundColor: Color(0xFF2D3748),
    controlBorderColor: Color(0xFF4A5568),
    controlIconColor: Color(0xFFA0AEC0),
    eraserPointerColor: Colors.white,
  );

  /// Creates a copy of this theme with some properties replaced.
  ScribbleTheme copyWith({
    Color? paperColor,
    Color? paperBorderColor,
    Color? paperShadowColor,
    Color? rowLineColor,
    Color? lineNumberColor,
    Color? controlBackgroundColor,
    Color? controlBorderColor,
    Color? controlIconColor,
    Color? eraserPointerColor,
  }) {
    return ScribbleTheme(
      paperColor: paperColor ?? this.paperColor,
      paperBorderColor: paperBorderColor ?? this.paperBorderColor,
      paperShadowColor: paperShadowColor ?? this.paperShadowColor,
      rowLineColor: rowLineColor ?? this.rowLineColor,
      lineNumberColor: lineNumberColor ?? this.lineNumberColor,
      controlBackgroundColor:
          controlBackgroundColor ?? this.controlBackgroundColor,
      controlBorderColor: controlBorderColor ?? this.controlBorderColor,
      controlIconColor: controlIconColor ?? this.controlIconColor,
      eraserPointerColor: eraserPointerColor ?? this.eraserPointerColor,
    );
  }

  /// Resolve a theme from a brightness value.
  static ScribbleTheme fromBrightness(Brightness brightness) {
    return brightness == Brightness.dark
        ? ScribbleTheme.dark
        : ScribbleTheme.light;
  }

  /// Resolve a theme using platform brightness from the given context.
  static ScribbleTheme fromContext(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    return fromBrightness(brightness);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ScribbleTheme &&
        other.paperColor == paperColor &&
        other.paperBorderColor == paperBorderColor &&
        other.paperShadowColor == paperShadowColor &&
        other.rowLineColor == rowLineColor &&
        other.lineNumberColor == lineNumberColor &&
        other.controlBackgroundColor == controlBackgroundColor &&
        other.controlBorderColor == controlBorderColor &&
        other.controlIconColor == controlIconColor &&
        other.eraserPointerColor == eraserPointerColor;
  }

  @override
  int get hashCode {
    return Object.hash(
      paperColor,
      paperBorderColor,
      paperShadowColor,
      rowLineColor,
      lineNumberColor,
      controlBackgroundColor,
      controlBorderColor,
      controlIconColor,
      eraserPointerColor,
    );
  }
}

/// Controls how notebook widgets derive their color theme.
enum ScribbleThemeMode {
  /// Follow the system/platform brightness (default)
  system,

  /// Force light theme
  light,

  /// Force dark theme
  dark,
}
