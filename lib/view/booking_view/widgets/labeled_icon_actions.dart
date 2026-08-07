// labeled_icon_actions.dart
//
// Icon-only actions that sit inline with the fields.
//
// Each icon is a real tab stop: Tab walks onto it, Enter or Space fires its
// onTap, and a focus border marks which one is armed — so the row works with
// no mouse. The three of them share the grid cell's NumericFocusOrder, and
// OrderedTraversalPolicy breaks that tie with its secondary reading-order
// sort, which walks them left to right.
//
// See create_new_booking_form.dart for how this fits into the wider form.

import 'package:flutter/material.dart';

import 'booking_form_layout.dart';

/// One entry in a [LabeledIconActions] row.
class IconAction {
  final IconData icon;

  /// Shown on hover / long-press and read out by screen readers, so the icon
  /// never has to carry its meaning alone.
  final String tooltip;
  final VoidCallback onTap;

  const IconAction({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });
}

class LabeledIconActions extends StatelessWidget {
  final List<IconAction> actions;

  /// Gap between icons. Also what [width] below assumes.
  static const double gap = 6;

  /// Square side of one icon button — matches a text field's rendered height
  /// (roughly 20 + 2 * fieldPadY) so the row lines up with the inputs.
  static const double buttonSide = 20 + 2 * Density.fieldPadY;

  const LabeledIconActions(this.actions, {super.key});

  /// Exact width [count] icons need, for the grid cell's `widths`.
  static double width(int count) =>
      buttonSide * count + gap * (count - 1);

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Same nudge the checkboxes take: in stacked mode the fields beside this
      // one carry a label above them, so drop down to stay aligned.
      padding: EdgeInsets.only(
        top: FormLayout.inlineOf(context)
            ? 0
            : Density.labelFont + Density.labelGap,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final (i, a) in actions.indexed)
            Padding(
              padding: EdgeInsets.only(
                  right: i == actions.length - 1 ? 0 : gap),
              child: _IconActionButton(a),
            ),
        ],
      ),
    );
  }
}

class _IconActionButton extends StatefulWidget {
  final IconAction action;
  const _IconActionButton(this.action);

  @override
  State<_IconActionButton> createState() => _IconActionButtonState();
}

class _IconActionButtonState extends State<_IconActionButton> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final accent = Theme.of(context).colorScheme.primary;
    return Tooltip(
      message: widget.action.tooltip,
      waitDuration: const Duration(milliseconds: 400),
      child: Semantics(
        button: true,
        label: widget.action.tooltip,
        child: InkWell(
          // Enter / Space reach a focused InkWell as an ActivateIntent, which
          // it already turns into a tap — no extra Shortcuts wiring needed.
          onTap: widget.action.onTap,
          onFocusChange: (has) {
            if (has != _focused) setState(() => _focused = has);
          },
          borderRadius: BorderRadius.circular(6),
          // The border below is the focus cue; Material's default focus fill
          // would only muddy it.
          focusColor: Colors.transparent,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            curve: Curves.easeOut,
            width: LabeledIconActions.buttonSide,
            height: LabeledIconActions.buttonSide,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _focused ? accent.withValues(alpha: 0.08) : Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: _focused ? accent : const Color(0xFFBDBDBD),
                width: _focused ? 1.4 : 1,
              ),
            ),
            child: Icon(
              widget.action.icon,
              size: 17,
              color: _focused ? accent : Colors.grey.shade700,
            ),
          ),
        ),
      ),
    );
  }
}
