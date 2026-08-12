import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Wraps a dialog's content so pressing Escape always closes it.
///
/// Flutter's own Escape-to-dismiss is narrower than it looks, and the booking
/// form's alerts fall outside it on two counts:
///
///  * `_DismissModalAction.isEnabled` (widgets/routes.dart) returns
///    `route.barrierDismissible`, so a dialog opened with
///    `barrierDismissible: false` — ExtraFaresAlert is — can never be closed
///    from the keyboard, however the key is routed.
///  * DismissIntent is dispatched from wherever primary focus happens to be.
///    These alerts are plain `Dialog`s, and the screens underneath keep their
///    own autofocus nodes alive (dashboard.dart's RawKeyboardListener, the
///    booking form's `_shortcutFocusNode`), so the key is not guaranteed to be
///    delivered inside the dialog's route at all.
///
/// Listening on [HardwareKeyboard] sidesteps both: the handler sees the key
/// wherever focus sits, and pops without consulting `barrierDismissible`. Only
/// the route that is currently on top reacts, so stacked dialogs close one at
/// a time and a dialog underneath never pops out from below the visible one.
class EscapeDismissible extends StatefulWidget {
  const EscapeDismissible({super.key, required this.child, this.onDismiss});

  final Widget child;

  /// Runs instead of popping the route — for a dialog that has to save or
  /// confirm before it closes.
  final VoidCallback? onDismiss;

  @override
  State<EscapeDismissible> createState() => _EscapeDismissibleState();
}

class _EscapeDismissibleState extends State<EscapeDismissible> {
  @override
  void initState() {
    super.initState();
    HardwareKeyboard.instance.addHandler(_onKey);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_onKey);
    super.dispose();
  }

  bool _onKey(KeyEvent event) {
    if (event is! KeyDownEvent ||
        event.logicalKey != LogicalKeyboardKey.escape) {
      return false;
    }
    if (!mounted) return false;
    final route = ModalRoute.of(context);
    if (route == null || !route.isCurrent) return false;

    if (widget.onDismiss != null) {
      widget.onDismiss!();
    } else {
      Navigator.of(context).maybePop();
    }
    // Consume it, so the key does not also reach a shortcut on the screen
    // behind this dialog.
    return true;
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
