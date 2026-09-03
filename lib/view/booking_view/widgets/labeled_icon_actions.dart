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

  /// Filled variant. Null leaves the default outlined button — white with a
  /// grey border — which is what the create form uses throughout. Set it for
  /// the solid buttons on the update form's PAY row.
  final Color? background;

  /// Icon colour. Defaults to white on a filled button and grey on an
  /// outlined one.
  final Color? foreground;

  const IconAction({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.background,
    this.foreground,
  });
}

class LabeledIconActions extends StatelessWidget {
  final List<IconAction> actions;

  /// Gap between icons. Also what [width] below assumes.
  static const double gap = 6;

  /// Square side of one icon button. [Density.buttonHeight] rather than
  /// [Density.fieldHeight]: the row still sits on the inputs' top edge, but a
  /// glyph needs less box around it than a caret does.
  static const double buttonSide = Density.buttonHeight;

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
    final filled = widget.action.background != null;
    // A filled button keeps its own colour on focus and shows the ring as a
    // border only — tinting the fill would wash the icon out. The dark fills
    // take a white ring, since indigo on near-black would not read.
    final Color ring =
        filled ? focusRingOn(widget.action.background!) : fieldFocusColor;
    final Color fill = filled
        ? widget.action.background!
        : (_focused ? fieldFocusColor.withValues(alpha: 0.08) : Colors.white);
    final Color border = filled
        ? (_focused ? ring : widget.action.background!)
        : (_focused ? ring : const Color(0xFFBDBDBD));
    final Color glyph = widget.action.foreground ??
        (filled
            ? Colors.white
            : (_focused ? fieldFocusColor : Colors.grey.shade700));
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
              color: fill,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                  color: border,
                  width: _focused ? fieldFocusWidth : fieldBorderWidth),
            ),
            child: Icon(widget.action.icon, size: 17, color: glyph),
          ),
        ),
      ),
    );
  }
}
