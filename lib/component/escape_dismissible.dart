import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Closes the dialog it wraps when the user presses Esc.
///
/// Flutter already maps Esc to a dismiss action for modal routes, but only when
/// the route is `barrierDismissible` — `_DismissModalAction.isEnabled` returns
/// `route.barrierDismissible`. The dashboard alerts are deliberately opened with
/// `barrierDismissible: false` (a stray click outside must not throw the form
/// away), which switches the built-in Esc off with it. Wrapping the dialog's
/// content in this widget brings Esc back without making the barrier tappable.
///
/// Usage:
/// ```dart
/// Get.dialog(
///   EscapeDismissible(child: Dialog(...)),
///   barrierDismissible: false,
/// );
/// ```
class EscapeDismissible extends StatefulWidget {
  const EscapeDismissible({super.key, required this.child, this.onDismiss});

  final Widget child;

  /// What Esc should do. Defaults to popping the route this widget is in, i.e.
  /// closing the dialog. Pass a callback to save / confirm first.
  final VoidCallback? onDismiss;

  @override
  State<EscapeDismissible> createState() => _EscapeDismissibleState();
}

class _EscapeDismissibleState extends State<EscapeDismissible> {
  /// Key events only travel up from the node that currently has focus. A dialog
  /// whose content has nothing focusable leaves focus on the route's own
  /// FocusScope — an ANCESTOR of this widget — and the binding below would
  /// never be reached. This node parks focus inside the wrapper instead, so Esc
  /// works before the user has touched anything in the dialog.
  ///
  /// skipTraversal keeps it out of the Tab order, and because it is an ancestor
  /// of the dialog's own controls it only ever sees Esc after they have passed
  /// on it — an inner autocomplete or menu that closes itself on Esc still
  /// wins, and the dialog stays open.
  final FocusNode _focusNode = FocusNode(
    debugLabel: 'EscapeDismissible',
    skipTraversal: true,
  );

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _dismiss() {
    final onDismiss = widget.onDismiss;
    if (onDismiss != null) {
      onDismiss();
      return;
    }
    // maybePop (not Get.back) so a PopScope inside the dialog can still veto.
    Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: <ShortcutActivator, VoidCallback>{
        const SingleActivator(LogicalKeyboardKey.escape): _dismiss,
      },
      child: Focus(
        focusNode: _focusNode,
        autofocus: true,
        child: widget.child,
      ),
    );
  }
}
