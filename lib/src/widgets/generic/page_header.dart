import "package:flutter/material.dart";
import "package:rover_dashboard/src/widgets/navigation/views_list.dart";

/// A widget for the header of a page
class PageHeader extends StatelessWidget {
  /// The index of the page within the views pane
  final int pageIndex;

  /// The contents of the header to display left of the views selector dropdown
  final List<Widget> children;

  /// The padding between the header contents and its border, defaults to 4
  final double innerPadding;

  /// Const constructor for page header, requiring the index, and children
  const PageHeader({
    required this.pageIndex,
    required this.children,
    this.innerPadding = 4,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Material(
    elevation: 5,
    child: Padding(
      padding: EdgeInsets.all(innerPadding),
      child: Row(
        children: [
          ...children,
          ViewsSelector(index: pageIndex),
        ],
      ),
    ),
  );
}
