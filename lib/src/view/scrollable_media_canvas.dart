import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:scribble/scribble.dart';
import 'package:scribble/src/domain/model/page/media_page.dart';
import 'package:scribble/src/view/notifier/media_canvas_notifier.dart';

class ScrollableMediaCanvas extends StatefulWidget {
  const ScrollableMediaCanvas({
    required this.notifier,
    this.showRowLines = false,
    this.rowLineSpacing = 24.0,
    this.rowLineColor = Colors.grey,
    this.rowLineWidth = 1.0,
    super.key,
  });

  final MediaCanvasNotifier notifier;
  final bool showRowLines;
  final double rowLineSpacing;
  final Color rowLineColor;
  final double rowLineWidth;

  @override
  State<ScrollableMediaCanvas> createState() => _ScrollableMediaCanvasState();
}

class _ScrollableMediaCanvasState extends State<ScrollableMediaCanvas> {
  late final ScribbleNotifier _scribbleNotifier;

  @override
  void initState() {
    super.initState();
    _scribbleNotifier = ScribbleNotifier(
      sketch: widget.notifier.pages.isNotEmpty
          ? widget.notifier.pages[widget.notifier.currentPageIndex].sketch
          : null,
    );
    widget.notifier.setScribbleNotifier(_scribbleNotifier);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.notifier,
      builder: (context, _) {
        return ListView.builder(
          itemCount: widget.notifier.pages.length,
          itemBuilder: (context, index) {
            final page = widget.notifier.pages[index];
            final isSelected = index == widget.notifier.currentPageIndex;
            return GestureDetector(
              onTap: () {
                widget.notifier.setCurrentPage(index);
              },
              child: Stack(
                children: [
                  if (page.mediaType == MediaType.image && page.imageData != null)
                    Image.memory(
                      page.imageData!,
                      fit: BoxFit.cover,
                      width: page.size.width,
                      height: page.size.height,
                    )
                  else if (page.mediaType == MediaType.pdf && page.pdfPath != null)
                    SizedBox(
                      width: page.size.width,
                      height: page.size.height,
                      child: PDFView(
                        filePath: page.pdfPath,
                      ),
                    ),
                  SizedBox(
                    width: page.size.width,
                    height: page.size.height,
                    child: CustomPaint(
                      painter: widget.showRowLines
                          ? _RowLinePainter(
                              rowLineSpacing: widget.rowLineSpacing,
                              lineColor: widget.rowLineColor,
                              lineWidth: widget.rowLineWidth,
                            )
                          : null,
                      child: isSelected
                          ? Scribble(
                              notifier: _scribbleNotifier,
                            )
                          : AbsorbPointer(
                              child: Scribble(
                                notifier: ScribbleNotifier(
                                  sketch: page.sketch,
                                ),
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _RowLinePainter extends CustomPainter {
  _RowLinePainter({
    required this.rowLineSpacing,
    required this.lineColor,
    required this.lineWidth,
  });

  final double rowLineSpacing;
  final Color lineColor;
  final double lineWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = lineWidth;

    for (double y = rowLineSpacing; y < size.height; y += rowLineSpacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_RowLinePainter oldDelegate) {
    return oldDelegate.rowLineSpacing != rowLineSpacing ||
        oldDelegate.lineColor != lineColor ||
        oldDelegate.lineWidth != lineWidth;
  }
}
