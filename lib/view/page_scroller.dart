import 'package:flutter/cupertino.dart';

import 'dashboard_view/utils/page_arrow_scroll.dart';

class PageScrollWrapper extends StatelessWidget {
  final Widget child;
  final FocusNode? focusNode;

  const PageScrollWrapper({
    super.key,
    required this.child,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: focusNode,
      skipTraversal: true,
      onKeyEvent: (node, event) => handlePageArrowScroll(context, event),
      child: child,
    );
  }
}