import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:scribble/scribble.dart';
import 'package:scribble/src/view/notifier/simple_notebook_notifier.dart';
import 'package:scribble/src/view/painting/scribble_editing_painter.dart';
import 'package:scribble/src/view/painting/scribble_painter.dart';
import 'package:scribble/src/view/state/simple_notebook_state.dart';

/// A simplified scrollable canvas widget that renders notebook pages
/// vertically.
///
/// This widget provides a clean multi-page drawing experience with:
/// - Vertical scrolling through all pages
/// - Basic drawing and erasing functionality
/// - Zoom and pan capabilities
/// - Automatic page management
class SimpleScrollableNotebook extends StatefulWidget {
  /// Creates a new simple scrollable notebook.
  const SimpleScrollableNotebook({
    /// The notifier that controls this notebook.
    required this.notifier,

    /// Whether to draw the pointer when in drawing mode
    this.drawPen = true,

    /// Whether to draw the pointer when in erasing mode
    this.drawEraser = true,

    /// Whether to simulate pressure for lines without pressure information
    this.simulatePressure = true,

    /// Theme configuration for colors. When provided, individual color
    /// parameters are ignored in favor of theme colors.
    this.theme,

    /// Control how the widget derives its theme (defaults to system).
    this.themeMode = ScribbleThemeMode.system,

    /// Optional external theme controller for advanced control.
    this.themeController,

    /// Background color for the paper. If null, uses white.
    /// Ignored if [theme] is provided.
    this.paperColor = Colors.white,

    /// Color for the paper border. If null, uses light gray.
    /// Ignored if [theme] is provided.
    this.paperBorderColor = Colors.grey,

    /// Width of the paper border in logical pixels.
    this.paperBorderWidth = 1.0,

    /// Whether to show the paper border.
    this.showPaperBorder = true,

    /// Whether to show a shadow under the paper.
    this.showPaperShadow = true,

    /// Spacing between pages in logical pixels.
    this.pageSpacing = 32,

    /// Whether to automatically add new pages when writing near the bottom.
    this.autoAddPages = false,

    /// Distance from bottom edge that triggers new page creation.
    this.bottomMarginThreshold = 50.0,
    super.key,
  });

  /// The notifier that controls this notebook.
  final SimpleNotebookNotifier notifier;

  /// Whether to draw the pointer when in drawing mode.
  final bool drawPen;

  /// Whether to draw the pointer when in erasing mode.
  final bool drawEraser;

  /// Whether to simulate pressure when drawing lines that don't have pressure
  /// information (all points have the same pressure).
  final bool simulatePressure;

  /// Theme configuration for colors. When provided, individual color
  /// parameters are ignored in favor of theme colors.
  final ScribbleTheme? theme;

  /// Theme derivation mode.
  final ScribbleThemeMode themeMode;

  /// Optional theme controller (advanced use). If provided, its theme is used
  /// unless an explicit [theme] is set.
  final ScribbleThemeController? themeController;

  /// Background color for the paper.
  final Color paperColor;

  /// Color for the paper border.
  final Color paperBorderColor;

  /// Width of the paper border in logical pixels.
  final double paperBorderWidth;

  /// Whether to show the paper border.
  final bool showPaperBorder;

  /// Whether to show a shadow under the paper.
  final bool showPaperShadow;

  /// Spacing between pages in logical pixels.
  final double pageSpacing;

  /// Whether to automatically add new pages when writing near the bottom.
  final bool autoAddPages;

  /// Distance from bottom edge that triggers new page creation.
  final double bottomMarginThreshold;

  @override
  State<SimpleScrollableNotebook> createState() =>
      _SimpleScrollableNotebookState();
}

class _SimpleScrollableNotebookState extends State<SimpleScrollableNotebook> {
  final ScrollController _scrollController = ScrollController();
  final Map<int, GlobalKey> _pageKeys = {};
  final TransformationController _transformationController =
      TransformationController();
  bool _isPenActive = false;
  double _currentZoom = 1;

  ScribbleTheme _effectiveTheme(BuildContext context) {
    if (widget.theme != null) return widget.theme!;
    if (widget.themeController != null) return widget.themeController!.theme;
    switch (widget.themeMode) {
      case ScribbleThemeMode.light:
        return ScribbleTheme.light;
      case ScribbleThemeMode.dark:
        return ScribbleTheme.dark;
      case ScribbleThemeMode.system:
        return ScribbleTheme.fromContext(context);
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.autoAddPages) {
      widget.notifier.setAutoAddPages(
        enabled: true,
        threshold: widget.bottomMarginThreshold,
      );
    }

    // Listen to transformation changes to update zoom level
    _transformationController.addListener(_onTransformationChanged);

    // Center the content initially
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _centerContent();
    });
  }

  void _centerContent() {
    if (!mounted) return;

    // Get the render box to calculate the available space
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final size = renderBox.size;
    if (size.isEmpty) return;

    // Calculate the content dimensions (rough estimate for pages)
    final state = widget.notifier.value;
    if (state.pages.isEmpty) return;

    // Estimate content height: pages + spacing
    final pageHeight = state.pages.first.paperSize.height;
    final pageWidth = state.pages.first.paperSize.width;
    final totalContentHeight = (state.pages.length * pageHeight) +
        ((state.pages.length - 1) * widget.pageSpacing) +
        (2 * widget.pageSpacing); // top and bottom padding

    // Calculate centering offsets
    final offsetX = (size.width - pageWidth) / 2;
    final offsetY = (size.height - totalContentHeight) / 2;

    // Only center if content is smaller than viewport
    final centerX = offsetX > 0 ? offsetX : 0.0;
    final centerY = offsetY > 0 ? offsetY : 0.0;

    final matrix = Matrix4.identity()..translate(centerX, centerY);

    _transformationController.value = matrix;
  }

  void _onTransformationChanged() {
    final matrix = _transformationController.value;
    final newZoom = matrix.getMaxScaleOnAxis();
    if (newZoom != _currentZoom) {
      setState(() {
        _currentZoom = newZoom;
      });
      // Update the notifier's zoom level
      widget.notifier.setZoomAndPan(zoomLevel: newZoom);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = _effectiveTheme(context);
    return ScribbleThemeProvider(
      theme: theme,
      child: ValueListenableBuilder<SimpleNotebookState>(
        valueListenable: widget.notifier,
        builder: (context, state, child) {
          return Container(
            color: theme.paperShadowColor.withValues(alpha: 0.1),
            child: ClipRect(
              child: InteractiveViewer(
                transformationController: _transformationController,
                minScale: 0.05,
                maxScale: 5,
                constrained: false,
                panEnabled: !_isPenActive,
                scaleEnabled: !_isPenActive,
                boundaryMargin: const EdgeInsets.all(double.infinity),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Padding(
                    padding: EdgeInsets.all(widget.pageSpacing),
                    child: Column(
                      children: [
                        for (int i = 0; i < state.pages.length; i++)
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: i < state.pages.length - 1
                                  ? widget.pageSpacing
                                  : 0,
                            ),
                            child: _buildPage(state, i, theme),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPage(
      SimpleNotebookState state, int pageIndex, ScribbleTheme theme) {
    final page = state.pages[pageIndex];
    final isCurrentPage = pageIndex == state.currentPageIndex;

    // Ensure page key exists
    _pageKeys[pageIndex] ??= GlobalKey();

    return Container(
      decoration: BoxDecoration(
        color: theme.paperColor,
        border: widget.showPaperBorder
            ? Border.all(
                color: theme.paperBorderColor,
                width: widget.paperBorderWidth,
              )
            : null,
        boxShadow: widget.showPaperShadow
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: SizedBox(
        width: page.paperSize.width,
        height: page.paperSize.height,
        child: RepaintBoundary(
          key: isCurrentPage ? widget.notifier.repaintBoundaryKey : null,
          child: Listener(
            onPointerDown: (event) {
              // Check if this is a pen/stylus input
              if (event.kind == PointerDeviceKind.stylus ||
                  event.kind == PointerDeviceKind.invertedStylus) {
                setState(() => _isPenActive = true);
              }
              // Switch to this page and start drawing
              widget.notifier.setCurrentPageIndex(pageIndex);
              widget.notifier.onPointerDown(event);
            },
            onPointerMove: isCurrentPage ? widget.notifier.onPointerMove : null,
            onPointerUp: isCurrentPage
                ? (event) {
                    widget.notifier.onPointerUp(event);
                    // Re-enable zoom/pan after pen input ends
                    if (event.kind == PointerDeviceKind.stylus ||
                        event.kind == PointerDeviceKind.invertedStylus) {
                      setState(() => _isPenActive = false);
                    }
                  }
                : null,
            child: CustomPaint(
              size: Size(page.paperSize.width, page.paperSize.height),
              painter: ScribblePainter(
                sketch: page.sketch,
                scaleFactor: state.scaleFactor,
                simulatePressure: widget.simulatePressure,
                theme: theme,
              ),
              foregroundPainter: isCurrentPage && state is SimpleNotebookDrawing
                  ? ScribbleEditingPainter(
                      state: ScribbleState.drawing(
                        sketch: page.sketch,
                        activeLine: state.activeLine,
                        selectedColor: state.selectedColor,
                        selectedWidth: state.selectedWidth,
                        scaleFactor: state.scaleFactor,
                        pointerPosition: state.pointerPosition,
                        allowedPointersMode: state.allowedPointersMode,
                        activePointerIds: state.activePointerIds,
                        simplificationTolerance: state.simplificationTolerance,
                      ),
                      drawPointer: widget.drawPen,
                      drawEraser: widget.drawEraser,
                      simulatePressure: widget.simulatePressure,
                      theme: theme,
                    )
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}
