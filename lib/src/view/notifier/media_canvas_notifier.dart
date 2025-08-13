import 'package:flutter/widgets.dart';
import 'package:scribble/scribble.dart';
import 'package:scribble/src/domain/model/page/media_page.dart';

class MediaCanvasNotifier extends ValueNotifier<ScribbleState> {
  MediaCanvasNotifier({
    List<MediaPage>? pages,
  })  : _pages = pages ?? [],
        super(ScribbleState.drawing(
          sketch: (pages != null && pages.isNotEmpty)
              ? pages.first.sketch
              : const Sketch(lines: []),
        ));

  final List<MediaPage> _pages;
  int _currentPageIndex = 0;

  List<MediaPage> get pages => _pages;

  int get currentPageIndex => _currentPageIndex;

  ScribbleNotifier? _currentScribbleNotifier;

  void setScribbleNotifier(ScribbleNotifier notifier) {
    _currentScribbleNotifier = notifier;
  }

  void addPage(MediaPage page) {
    _pages.add(page);
    notifyListeners();
  }

  void removePage(int index) {
    if (index >= 0 && index < _pages.length) {
      _pages.removeAt(index);
      if (_currentPageIndex >= _pages.length) {
        _currentPageIndex = _pages.length - 1;
      }
      notifyListeners();
    }
  }

  void setCurrentPage(int index) {
    if (index >= 0 && index < _pages.length) {
      _currentPageIndex = index;
      final newSketch = _pages[index].sketch;
      _currentScribbleNotifier?.setSketch(sketch: newSketch);
      notifyListeners();
    }
  }
}
