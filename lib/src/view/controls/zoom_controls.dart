import 'package:flutter/material.dart';
import 'package:scribble/scribble.dart';
import 'package:scribble/src/view/notifier/notebook_notifier.dart';

/// A widget that provides zoom controls for a notebook canvas.
///
/// Includes zoom in, zoom out, fit to screen, and actual size buttons.
/// Also displays the current zoom level.
class ZoomControls extends StatelessWidget {
  /// Creates zoom controls for the given notebook notifier.
  const ZoomControls({
    required this.notifier,
    this.theme,
    this.showZoomLevel = true,
    this.iconSize = 24,
    this.buttonPadding = const EdgeInsets.all(8),
    super.key,
  });

  /// The notebook notifier to control.
  final NotebookNotifier notifier;

  /// Theme configuration for colors.
  final ScribbleTheme? theme;

  /// Whether to show the current zoom level.
  final bool showZoomLevel;

  /// Size of the control icons.
  final double iconSize;

  /// Padding around the buttons.
  final EdgeInsets buttonPadding;

  /// Common zoom levels for quick access.
  static const List<double> _commonZoomLevels = [
    0.25,
    0.5,
    0.75,
    1.0,
    1.25,
    1.5,
    2.0,
    3.0,
    4.0,
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: notifier,
      builder: (context, state, _) {
        final currentZoom = state.zoomLevel;
        final zoomPercentage = (currentZoom * 100).round();
        // Resolve theme: prefer provided theme, else provider/system fallback
        final ScribbleTheme t = theme ?? ScribbleThemeProvider.resolve(context);

        return Card(
          color: t.controlBackgroundColor,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Zoom Out Button
                IconButton(
                  onPressed: _zoomOut,
                  icon: Icon(
                    Icons.zoom_out,
                    size: iconSize,
                    color: t.controlIconColor,
                  ),
                  tooltip: 'Zoom Out',
                  padding: buttonPadding,
                ),

                const SizedBox(height: 4),

                // Current Zoom Level
                if (showZoomLevel) ...[
                  GestureDetector(
                    onTap: () => _showZoomMenu(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: t.controlBorderColor,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '$zoomPercentage%',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: t.controlIconColor,
                            ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                ],

                // Zoom In Button
                IconButton(
                  onPressed: _zoomIn,
                  icon: Icon(
                    Icons.zoom_in,
                    size: iconSize,
                    color: t.controlIconColor,
                  ),
                  tooltip: 'Zoom In',
                  padding: buttonPadding,
                ),

                const SizedBox(height: 8),

                // Fit to Screen Button
                IconButton(
                  onPressed: _fitToScreen,
                  icon: Icon(
                    Icons.fit_screen,
                    size: iconSize,
                    color: t.controlIconColor,
                  ),
                  tooltip: 'Fit to Screen',
                  padding: buttonPadding,
                ),

                const SizedBox(height: 4),

                // Actual Size Button (100%)
                IconButton(
                  onPressed: _actualSize,
                  icon: Icon(
                    Icons.crop_free,
                    size: iconSize,
                    color: t.controlIconColor,
                  ),
                  tooltip: 'Actual Size (100%)',
                  padding: buttonPadding,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Zooms in by increasing the zoom level.
  void _zoomIn() {
    final currentZoom = notifier.value.zoomLevel;
    final nextZoom = _findNextZoomLevel(currentZoom, true);
    notifier.setZoomLevel(nextZoom);
  }

  /// Zooms out by decreasing the zoom level.
  void _zoomOut() {
    final currentZoom = notifier.value.zoomLevel;
    final nextZoom = _findNextZoomLevel(currentZoom, false);
    notifier.setZoomLevel(nextZoom);

    // Auto-center when zooming down to 1.0 or below
    if (nextZoom <= 1.0 && currentZoom > 1.0) {
      notifier.setPanOffset(Offset.zero);
    }
  }

  /// Sets zoom to fit the paper in the available screen space.
  /// This is a simplified implementation - in a real app you'd calculate
  /// based on available viewport size and paper dimensions.
  void _fitToScreen() {
    // For now, set to a reasonable "fit" zoom level
    notifier.setZoomLevel(0.75);
    // Center the paper when fitting to screen
    notifier.setPanOffset(Offset.zero);
  }

  /// Sets zoom to 100% (actual size).
  void _actualSize() {
    notifier.setZoomLevel(1);
    // Center the paper when going to actual size
    notifier.setPanOffset(Offset.zero);
  }

  /// Finds the next appropriate zoom level based on common zoom levels.
  double _findNextZoomLevel(double currentZoom, bool zoomIn) {
    if (zoomIn) {
      // Find the next higher zoom level
      for (final level in _commonZoomLevels) {
        if (level > currentZoom + 0.01) {
          return level;
        }
      }
      // If we're already at the highest level, increase by 25%
      return (currentZoom * 1.25).clamp(0.1, 10);
    } else {
      // Find the next lower zoom level
      for (final level in _commonZoomLevels.reversed) {
        if (level < currentZoom - 0.01) {
          return level;
        }
      }
      // If we're already at the lowest level, decrease by 25%
      return (currentZoom * 0.8).clamp(0.1, 10);
    }
  }

  /// Shows a menu with common zoom levels for quick selection.
  void _showZoomMenu(BuildContext context) {
    showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(100, 100, 100, 100),
      items: _commonZoomLevels.map((level) {
        final percentage = (level * 100).round();
        return PopupMenuItem<double>(
          value: level,
          child: Text('$percentage%'),
        );
      }).toList(),
    ).then((selectedZoom) {
      if (selectedZoom != null) {
        notifier.setZoomLevel(selectedZoom);
      }
    });
  }
}
