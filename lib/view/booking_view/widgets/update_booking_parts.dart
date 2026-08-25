// update_booking_parts.dart
//
// Chrome specific to the UPDATE BOOKING form (see edit_jobs.dart), built on
// the same layout primitives as the create form:
//   * UpdateFormPalette — the indigos / reds this screen is styled in.
//   * UpdateBookingHeader — the top bar: reference, who booked it and when,
//     status, the associated booking, and the per-booking actions.
//   * MetaChip / StatusPill — the read-only labelled values in that bar.
//   * PillButton — the outlined COMPLAINT / LOST PROPERTY / ASSOCIATED
//     buttons, and the solid ones along the bottom.
//   * LabeledActionButton — a button shaped like a field, so it can sit in a
//     ResponsiveGrid cell and line up with the inputs beside it (PICK
//     BOOKING).
//   * FaresBar — the ETA / DISTANCE / T-FARES strip with the FARE and R/FARE
//     fields and the recalculate button on the same line.
//   * UpdateActionButtons — CANCEL / RECEIPT / AUDIT REPORT / SAVE.
//
// Everything here is presentation only: each action takes a VoidCallback the
// screen supplies, and nothing reaches for a controller of its own.

import 'package:flutter/material.dart';

import 'booking_form_layout.dart';
import 'booking_form_parts.dart' show BookingStat, StatStrip;

/// The update form's colours, kept in one place so the header pills, the
/// bottom buttons and the solid icon actions cannot drift apart.
class UpdateFormPalette {
  /// Confirmations and anything to do with the booking going ahead.
  /// Named `green` for the role it plays, not the hue it now carries.
  static const Color green = Color(0xFF312E81);

  /// Complaints — the one destructive-looking action in the header.
  static const Color red = Color(0xFFD9412B);

  /// Fill behind a read-only value.
  static const Color chip = Color(0xFFF1F1F1);
  static const Color border = Color(0xFFE0E0E0);
  static const Color labelText = Color(0xFF6B6B6B);
  static const Color valueText = Color(0xFF1F1F1F);

  /// Height every header control shares, so a row of them has one baseline.
  static const double controlHeight = 26;

  /// Height of a control that has to line up with a form field —
  /// [LabeledActionButton] and the fare bar's recalculate button. Matches a
  /// dense input's rendered height.
  static const double fieldHeight = Density.fieldHeight;
}

// ---------------------------------------------------------------------------
// Read-only values in the header.
// ---------------------------------------------------------------------------

/// A grey pill holding a caption and the value beside it — USER NADEEM,
/// BOOKED 24-08-26 09:20.
class MetaChip extends StatelessWidget {
  final String label;
  final String value;

  /// Colours the value only; the caption stays grey either way. STATUS uses it
  /// to call out WAITING in the accent.
  final Color valueColor;

  const MetaChip({
    super.key,
    required this.label,
    required this.value,
    this.valueColor = UpdateFormPalette.valueText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: UpdateFormPalette.controlHeight,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: UpdateFormPalette.chip,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.4,
              color: UpdateFormPalette.labelText,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.3,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}

/// The booking reference itself — the same pill shape as [MetaChip] but with
/// no caption, since the title beside it already says what it is.
class ReferencePill extends StatelessWidget {
  final String reference;
  const ReferencePill(this.reference, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: UpdateFormPalette.controlHeight,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: UpdateFormPalette.chip,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        reference,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.4,
          color: UpdateFormPalette.green,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Buttons.
// ---------------------------------------------------------------------------

/// A short pill button. Outlined by default — white with a coloured border and
/// matching text — or solid when [filled] is set, which is what the bottom row
/// uses.
///
/// A real tab stop, with the same animated focus border the icon actions use,
/// so the header works from the keyboard alone.
class PillButton extends StatefulWidget {
  final String label;
  final IconData? icon;

  /// Border and text when outlined; the fill when [filled].
  final Color color;
  final bool filled;
  final VoidCallback? onPressed;

  /// Tab position among the form's other stops. The header sits ahead of every
  /// field, the bottom row after them.
  final int order;

  const PillButton({
    super.key,
    required this.label,
    required this.order,
    this.icon,
    this.color = UpdateFormPalette.green,
    this.filled = false,
    this.onPressed,
  });

  @override
  State<PillButton> createState() => _PillButtonState();
}

class _PillButtonState extends State<PillButton> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    // A filled pill needs a ring that reads against its own colour; an
    // outlined one is white underneath, so the indigo always shows.
    final ring = widget.filled ? focusRingOn(widget.color) : fieldFocusColor;
    final fg = widget.filled ? Colors.white : widget.color;

    return FocusTraversalOrder(
      order: NumericFocusOrder(widget.order.toDouble()),
      child: Semantics(
        button: true,
        label: widget.label,
        child: InkWell(
          onTap: widget.onPressed,
          onFocusChange: (has) {
            if (has != _focused) setState(() => _focused = has);
          },
          borderRadius: BorderRadius.circular(6),
          // The border below is the focus cue; a fill on top of it would only
          // muddy the two-colour scheme.
          focusColor: Colors.transparent,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            curve: Curves.easeOut,
            height: UpdateFormPalette.controlHeight,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: widget.filled ? widget.color : Colors.white,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: _focused ? ring : widget.color,
                width: _focused ? fieldFocusWidth : fieldBorderWidth,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.icon != null) ...[
                  Icon(widget.icon, size: 13, color: fg),
                  const SizedBox(width: 5),
                ],
                Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.4,
                    color: fg,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Square icon button sized to match [PillButton], for the play / comment /
/// send trio in the header. Outlined in [color], like the pills beside it.
class PillIconButton extends StatefulWidget {
  final IconData icon;
  final String tooltip;
  final Color color;
  final VoidCallback? onPressed;
  final int order;

  const PillIconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    required this.order,
    this.color = UpdateFormPalette.green,
    this.onPressed,
  });

  @override
  State<PillIconButton> createState() => _PillIconButtonState();
}

class _PillIconButtonState extends State<PillIconButton> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return FocusTraversalOrder(
      order: NumericFocusOrder(widget.order.toDouble()),
      child: Tooltip(
        message: widget.tooltip,
        waitDuration: const Duration(milliseconds: 400),
        child: Semantics(
          button: true,
          label: widget.tooltip,
          child: InkWell(
            onTap: widget.onPressed,
            onFocusChange: (has) {
              if (has != _focused) setState(() => _focused = has);
            },
            borderRadius: BorderRadius.circular(6),
            focusColor: Colors.transparent,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 140),
              curve: Curves.easeOut,
              width: 34,
              height: UpdateFormPalette.controlHeight,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: _focused ? fieldFocusColor : widget.color,
                  width: _focused ? fieldFocusWidth : fieldBorderWidth,
                ),
              ),
              child: Icon(widget.icon, size: 15, color: widget.color),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// The header bar.
// ---------------------------------------------------------------------------

/// The strip above the form: which booking this is, who raised it and when,
/// where it has got to, and the actions that apply to the booking as a whole.
///
/// Reflows at [Breakpoints.desktop]: side by side above it, stacked below,
/// and each half is a Wrap so it keeps breaking as the window narrows.
class UpdateBookingHeader extends StatelessWidget {
  final String title;
  final String reference;
  final String user;
  final String bookedAt;
  final String status;

  /// The other leg of a linked pair. Null hides the pill.
  final String? associatedReference;

  final VoidCallback? onAssociatedTap;
  final VoidCallback? onTrack;
  final VoidCallback? onMessages;
  final VoidCallback? onDispatch;
  final VoidCallback? onComplaint;
  final VoidCallback? onLostProperty;

  const UpdateBookingHeader({
    super.key,
    this.title = 'UPDATE BOOKING',
    required this.reference,
    required this.user,
    required this.bookedAt,
    required this.status,
    this.associatedReference,
    this.onAssociatedTap,
    this.onTrack,
    this.onMessages,
    this.onDispatch,
    this.onComplaint,
    this.onLostProperty,
  });

  @override
  Widget build(BuildContext context) {
    // 1..99 — ahead of every field, which starts at 100.
    final identity = <Widget>[
      Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
          color: UpdateFormPalette.valueText,
        ),
      ),
      ReferencePill(reference),
      MetaChip(label: 'USER', value: user),
      MetaChip(label: 'BOOKED', value: bookedAt),
      MetaChip(
        label: 'STATUS',
        value: status,
        valueColor: UpdateFormPalette.green,
      ),
    ];

    final actions = <Widget>[
      if (associatedReference != null)
        PillButton(
          label: 'ASSOCIATED: $associatedReference',
          icon: Icons.link,
          order: 10,
          onPressed: onAssociatedTap,
        ),
      PillIconButton(
        icon: Icons.play_arrow,
        tooltip: 'TRACK JOURNEY',
        order: 11,
        onPressed: onTrack,
      ),
      PillIconButton(
        icon: Icons.chat_bubble_outline,
        tooltip: 'MESSAGES',
        order: 12,
        onPressed: onMessages,
      ),
      PillIconButton(
        icon: Icons.send,
        tooltip: 'DISPATCH',
        order: 13,
        onPressed: onDispatch,
      ),
      PillButton(
        label: 'COMPLAINT',
        icon: Icons.error_outline,
        color: UpdateFormPalette.red,
        order: 14,
        onPressed: onComplaint,
      ),
      PillButton(
        label: 'LOST PROPERTY',
        icon: Icons.inventory_2_outlined,
        order: 15,
        onPressed: onLostProperty,
      ),
    ];

    // Both halves centre their children vertically so the title text sits on
    // the same line as the pills, whatever the tallest control turns out to be.
    Widget group(List<Widget> children, WrapAlignment alignment) => Wrap(
          spacing: 6,
          runSpacing: 6,
          alignment: alignment,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: children,
        );

    return SectionCard(
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < Breakpoints.desktop) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                group(identity, WrapAlignment.start),
                const SizedBox(height: Density.gridSpacing),
                group(actions, WrapAlignment.start),
              ],
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: group(identity, WrapAlignment.start)),
              const SizedBox(width: Density.gridSpacing),
              // Flexible, not fixed: on a window only just past the desktop
              // breakpoint the action half is what has to give and wrap.
              Flexible(child: group(actions, WrapAlignment.end)),
            ],
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// A button that behaves like a field.
// ---------------------------------------------------------------------------

/// A button the height of an input, so it can be dropped into a
/// [ResponsiveGrid] cell and line up with the fields around it — PICK BOOKING
/// on the contact row.
///
/// Implements [LabelledField] so the grid can key its cell; pass an empty
/// [label] for a button that continues the row before it rather than starting
/// one of its own.
class LabeledActionButton extends StatefulWidget implements LabelledField {
  @override
  final String label;

  /// Text on the button itself, as distinct from [label], which is the caption
  /// in the form's label column.
  final String text;
  final IconData? icon;
  final Color background;
  final Color foreground;
  final VoidCallback? onPressed;

  const LabeledActionButton({
    super.key,
    this.label = '',
    required this.text,
    this.icon,
    this.background = UpdateFormPalette.chip,
    this.foreground = UpdateFormPalette.valueText,
    this.onPressed,
  });

  @override
  State<LabeledActionButton> createState() => _LabeledActionButtonState();
}

class _LabeledActionButtonState extends State<LabeledActionButton> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final ring = focusRingOn(widget.background);
    return FieldShell(
      label: widget.label,
      child: Semantics(
        button: true,
        label: widget.text,
        child: InkWell(
          onTap: widget.onPressed,
          onFocusChange: (has) {
            if (has != _focused) setState(() => _focused = has);
          },
          borderRadius: BorderRadius.circular(4),
          focusColor: Colors.transparent,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            curve: Curves.easeOut,
            height: UpdateFormPalette.fieldHeight,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: widget.background,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: _focused ? ring : UpdateFormPalette.border,
                width: _focused ? fieldFocusWidth : fieldBorderWidth,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.icon != null) ...[
                  Icon(widget.icon, size: 14, color: widget.foreground),
                  const SizedBox(width: 5),
                ],
                Flexible(
                  child: Text(
                    widget.text,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.4,
                      color: widget.foreground,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// The fares bar.
// ---------------------------------------------------------------------------

/// The costed figures and the fares they produced, on one line: the ETA /
/// DISTANCE / T-FARES strip on the left, then FARE, R/FARE and the button that
/// recalculates them.
///
/// Laid out by hand rather than through [ResponsiveGrid] because the stat strip
/// is not a field — it has no label column and wants whatever width is left
/// over. Below [Breakpoints.desktop] the strip moves onto its own line above
/// the fields.
class FaresBar extends StatelessWidget {
  final List<BookingStat> stats;

  /// The FARE / R/FARE fields, supplied by the screen so it keeps ownership of
  /// their controllers. R/FARE is dropped from the list on a one-way booking,
  /// so this takes however many it is given.
  final List<Widget> fareFields;

  final VoidCallback? onRecalculate;

  /// Tab position of the first fare field; each following one takes the next
  /// number and the recalculate button comes after them.
  ///
  /// Not optional in practice: [OrderedTraversalPolicy] puts every node it
  /// finds no [FocusTraversalOrder] on *after* all the ordered ones, so a fare
  /// field left unordered would be tabbed to after the SAVE button rather than
  /// in its place on the form.
  final int orderBase;

  const FaresBar({
    super.key,
    required this.stats,
    required this.fareFields,
    this.onRecalculate,
    this.orderBase = 400,
  });

  @override
  Widget build(BuildContext context) {
    Widget ordered(int order, Widget child) => FocusTraversalOrder(
          order: NumericFocusOrder(order.toDouble()),
          child: child,
        );

    final recalculate = ordered(orderBase + fareFields.length,
        _RecalculateButton(onPressed: onRecalculate));

    // Each field gets an equal share of the fields half, so FARE and R/FARE
    // stay the same width as each other however many there are.
    List<Widget> spacedFields() => [
          for (final (i, f) in fareFields.indexed) ...[
            if (i > 0) const SizedBox(width: Density.gridSpacing),
            Expanded(child: ordered(orderBase + i, f)),
          ],
        ];

    return SectionCard(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final fields = Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ...spacedFields(),
              const SizedBox(width: Density.gridSpacing),
              recalculate,
            ],
          );

          if (constraints.maxWidth < Breakpoints.desktop) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StatStrip(stats: stats),
                const SizedBox(height: Density.gridSpacing),
                fields,
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: StatStrip(stats: stats)),
              const SizedBox(width: Density.gridSpacing),
              // Half the bar for the fares, matching the two grid columns the
              // fields would have taken had they been laid out on the grid.
              SizedBox(width: constraints.maxWidth / 2, child: fields),
            ],
          );
        },
      ),
    );
  }
}

/// The calculator button at the end of the fares bar. Wider than a square icon
/// button because the design gives it the width of a short field.
class _RecalculateButton extends StatefulWidget {
  final VoidCallback? onPressed;
  const _RecalculateButton({this.onPressed});

  @override
  State<_RecalculateButton> createState() => _RecalculateButtonState();
}

class _RecalculateButtonState extends State<_RecalculateButton> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: 'RECALCULATE FARES',
      waitDuration: const Duration(milliseconds: 400),
      child: Semantics(
        button: true,
        label: 'RECALCULATE FARES',
        child: InkWell(
          onTap: widget.onPressed,
          onFocusChange: (has) {
            if (has != _focused) setState(() => _focused = has);
          },
          borderRadius: BorderRadius.circular(4),
          focusColor: Colors.transparent,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            curve: Curves.easeOut,
            width: 84,
            height: UpdateFormPalette.fieldHeight,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: UpdateFormPalette.chip,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: _focused ? fieldFocusColor : UpdateFormPalette.border,
                width: _focused ? fieldFocusWidth : fieldBorderWidth,
              ),
            ),
            child: const Icon(Icons.calculate_outlined,
                size: 17, color: UpdateFormPalette.valueText),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// The bottom actions.
// ---------------------------------------------------------------------------

/// CANCEL / RECEIPT / AUDIT REPORT / SAVE.
///
/// Right-aligned and hugging their text on a wide screen, so they sit beside
/// the driver fields the way the design has them; full-width and stacked once
/// the row can no longer hold them.
class UpdateActionButtons extends StatelessWidget {
  final VoidCallback? onCancel;
  final VoidCallback? onReceipt;
  final VoidCallback? onAuditReport;
  final VoidCallback? onSave;

  const UpdateActionButtons({
    super.key,
    this.onCancel,
    this.onReceipt,
    this.onAuditReport,
    this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    // 700+ keeps these last in the tab order, after every field.
    final buttons = <Widget>[
      PillButton(
          label: 'CANCEL', order: 700, filled: true, onPressed: onCancel),
      PillButton(
          label: 'RECEIPT', order: 701, filled: true, onPressed: onReceipt),
      PillButton(
          label: 'AUDIT REPORT',
          order: 702,
          filled: true,
          onPressed: onAuditReport),
      PillButton(label: 'SAVE', order: 703, filled: true, onPressed: onSave),
    ];

    return Padding(
      // The same nudge the checkboxes take, so a stacked layout puts these on
      // the baseline of the labelled fields beside them.
      padding: EdgeInsets.only(
        top: FormLayout.inlineOf(context)
            ? 0
            : Density.labelFont + Density.labelGap,
      ),
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        alignment: WrapAlignment.end,
        children: buttons,
      ),
    );
  }
}
