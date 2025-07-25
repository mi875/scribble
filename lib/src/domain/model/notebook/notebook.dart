import 'package:flutter/foundation.dart';
import 'package:scribble/src/domain/model/page/page.dart';
import 'package:scribble/src/domain/model/paper_size/paper_size.dart';

/// Represents a notebook containing multiple pages with navigation state.
@immutable
class Notebook {
  /// Creates a new notebook with the specified properties.
  const Notebook({
    required this.id,
    required this.pages,
    this.currentPageIndex = 0,
    this.name,
  }) : assert(pages.length > 0, 'Notebook must have at least one page'),
       assert(
         currentPageIndex >= 0 && currentPageIndex < pages.length,
         'Current page index must be within bounds',
       );

  /// Creates a new notebook with a single blank page.
  factory Notebook.blank({
    required String id,
    required PaperSize paperSize,
    String? name,
  }) {
    return Notebook(
      id: id,
      pages: [
        NotebookPage.blank(
          id: '${id}_page_0',
          paperSize: paperSize,
        ),
      ],
      name: name,
    );
  }

  /// Unique identifier for this notebook.
  final String id;

  /// List of pages in this notebook.
  final List<NotebookPage> pages;

  /// Index of the currently active page.
  final int currentPageIndex;

  /// Optional name for the notebook.
  final String? name;

  /// Returns the currently active page.
  NotebookPage get currentPage => pages[currentPageIndex];

  /// Returns true if this is the first page.
  bool get isFirstPage => currentPageIndex == 0;

  /// Returns true if this is the last page.
  bool get isLastPage => currentPageIndex == pages.length - 1;

  /// Returns the total number of pages.
  int get pageCount => pages.length;

  /// Creates a copy of this notebook with optional overrides.
  Notebook copyWith({
    String? id,
    List<NotebookPage>? pages,
    int? currentPageIndex,
    String? name,
  }) {
    return Notebook(
      id: id ?? this.id,
      pages: pages ?? this.pages,
      currentPageIndex: currentPageIndex ?? this.currentPageIndex,
      name: name ?? this.name,
    );
  }

  /// Creates a new notebook with a page added at the specified index.
  Notebook addPage(NotebookPage page, {int? index}) {
    final insertIndex = index ?? pages.length;
    final newPages = List<NotebookPage>.from(pages)
      ..insert(insertIndex, page);

    return copyWith(
      pages: newPages,
      currentPageIndex: insertIndex <= currentPageIndex
          ? currentPageIndex + 1
          : currentPageIndex,
    );
  }

  /// Creates a new notebook with the page at the specified index removed.
  Notebook removePage(int index) {
    if (pages.length <= 1) {
      throw ArgumentError('Cannot remove the last page');
    }
    if (index < 0 || index >= pages.length) {
      throw ArgumentError('Page index out of bounds');
    }

    final newPages = List<NotebookPage>.from(pages)
      ..removeAt(index);

    var newCurrentIndex = currentPageIndex;
    if (index < currentPageIndex) {
      newCurrentIndex = currentPageIndex - 1;
    } else if (index == currentPageIndex && 
               currentPageIndex == pages.length - 1) {
      newCurrentIndex = pages.length - 2;
    }

    return copyWith(
      pages: newPages,
      currentPageIndex: newCurrentIndex,
    );
  }

  /// Creates a new notebook with the current page set to the next page.
  Notebook nextPage() {
    if (isLastPage) return this;
    return copyWith(currentPageIndex: currentPageIndex + 1);
  }

  /// Creates a new notebook with the current page set to the previous page.
  Notebook previousPage() {
    if (isFirstPage) return this;
    return copyWith(currentPageIndex: currentPageIndex - 1);
  }

  /// Creates a new notebook with the current page set to the specified index.
  Notebook goToPage(int index) {
    if (index < 0 || index >= pages.length) {
      throw ArgumentError('Page index out of bounds');
    }
    return copyWith(currentPageIndex: index);
  }

  /// Creates a new notebook with the current page updated.
  Notebook updateCurrentPage(NotebookPage page) {
    final newPages = List<NotebookPage>.from(pages);
    newPages[currentPageIndex] = page;
    return copyWith(pages: newPages);
  }

  /// Creates a new notebook with a page at the specified index updated.
  Notebook updatePage(int index, NotebookPage page) {
    if (index < 0 || index >= pages.length) {
      throw ArgumentError('Page index out of bounds');
    }
    final newPages = List<NotebookPage>.from(pages);
    newPages[index] = page;
    return copyWith(pages: newPages);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Notebook &&
        other.id == id &&
        listEquals(other.pages, pages) &&
        other.currentPageIndex == currentPageIndex &&
        other.name == name;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        pages.hashCode ^
        currentPageIndex.hashCode ^
        name.hashCode;
  }

  @override
  String toString() {
    return 'Notebook(id: $id, pages: ${pages.length}, '
        'currentPageIndex: $currentPageIndex, name: $name)';
  }
}
