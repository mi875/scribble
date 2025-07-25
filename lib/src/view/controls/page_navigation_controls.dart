import 'package:flutter/material.dart';
import 'package:scribble/src/view/notifier/notebook_notifier.dart';

/// A widget that provides page navigation controls for a notebook.
/// 
/// Includes previous/next page buttons, page indicator, and add/remove page
/// functionality.
class PageNavigationControls extends StatelessWidget {
  /// Creates page navigation controls for the given notebook notifier.
  const PageNavigationControls({
    required this.notifier,
    this.showPageIndicator = true,
    this.showAddRemoveButtons = true,
    this.iconSize = 24,
    super.key,
  });

  /// The notebook notifier to control.
  final NotebookNotifier notifier;

  /// Whether to show the current page indicator.
  final bool showPageIndicator;

  /// Whether to show add/remove page buttons.
  final bool showAddRemoveButtons;

  /// Size of the control icons.
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: notifier,
      builder: (context, state, _) {
        final notebook = state.notebook;
        final currentPageIndex = notebook.currentPageIndex;
        final totalPages = notebook.pageCount;
        final isFirstPage = notebook.isFirstPage;
        final isLastPage = notebook.isLastPage;

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Previous Page Button
                IconButton(
                  onPressed: isFirstPage ? null : notifier.previousPage,
                  icon: Icon(
                    Icons.chevron_left,
                    size: iconSize,
                  ),
                  tooltip: 'Previous Page',
                ),

                const SizedBox(width: 8),

                // Page Indicator
                if (showPageIndicator) ...[
                  GestureDetector(
                    onTap: () => _showPageMenu(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${currentPageIndex + 1} / $totalPages',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],

                // Next Page Button
                IconButton(
                  onPressed: isLastPage ? null : notifier.nextPage,
                  icon: Icon(
                    Icons.chevron_right,
                    size: iconSize,
                  ),
                  tooltip: 'Next Page',
                ),

                // Add/Remove Page Controls
                if (showAddRemoveButtons) ...[
                  const SizedBox(width: 16),
                  const VerticalDivider(width: 1),
                  const SizedBox(width: 16),

                  // Add Page Button
                  IconButton(
                    onPressed: () => _addPage(context),
                    icon: Icon(
                      Icons.add,
                      size: iconSize,
                    ),
                    tooltip: 'Add Page',
                  ),

                  // Remove Page Button
                  IconButton(
                    onPressed: totalPages <= 1
                        ? null
                        : () => _removePage(context),
                    icon: Icon(
                      Icons.remove,
                      size: iconSize,
                    ),
                    tooltip: 'Remove Current Page',
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  /// Shows a menu to navigate to a specific page.
  void _showPageMenu(BuildContext context) {
    final notebook = notifier.currentNotebook;
    final totalPages = notebook.pageCount;

    if (totalPages <= 1) return;

    showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(100, 100, 100, 100),
      items: List.generate(totalPages, (index) {
        final pageNumber = index + 1;
        final isCurrentPage = index == notebook.currentPageIndex;
        
        return PopupMenuItem<int>(
          value: index,
          child: Row(
            children: [
              if (isCurrentPage)
                Icon(
                  Icons.check,
                  size: 16,
                  color: Theme.of(context).primaryColor,
                )
              else
                const SizedBox(width: 16),
              const SizedBox(width: 8),
              Text('Page $pageNumber'),
            ],
          ),
        );
      }),
    ).then((selectedPageIndex) {
      if (selectedPageIndex != null) {
        notifier.goToPage(selectedPageIndex);
      }
    });
  }

  /// Shows a dialog to add a new page.
  void _addPage(BuildContext context) {
    // For now, just add a page with the same paper size as current
    notifier.addPage();
    
    // Show a brief snackbar confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('New page added'),
        duration: const Duration(seconds: 2),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // Remove the last page (the one we just added)
            final currentNotebook = notifier.currentNotebook;
            if (currentNotebook.pageCount > 1) {
              notifier.removePage(currentNotebook.pageCount - 1);
            }
          },
        ),
      ),
    );
  }

  /// Shows a confirmation dialog to remove the current page.
  void _removePage(BuildContext context) {
    final currentPageNumber = notifier.currentNotebook.currentPageIndex + 1;
    
    showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Page'),
        content: Text(
          'Are you sure you want to remove page $currentPageNumber? '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Remove'),
          ),
        ],
      ),
    ).then((confirmed) {
      if (confirmed ?? false) {
        notifier.removePage(notifier.currentNotebook.currentPageIndex);
        
        // Show confirmation
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Page removed'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    });
  }
}
