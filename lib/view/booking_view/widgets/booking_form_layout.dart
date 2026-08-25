// booking_form_layout.dart
//
// Shared layout infrastructure for the booking form split
// (see create_new_booking_form.dart for the full picture):
//   * Density / Breakpoints — the two knobs that tune field height and
//     column count for the whole form.
//   * FormLayout — carries the label-placement decision (inline vs stacked)
//     down to every field from a single LayoutBuilder.
//   * FieldShell / FieldLabel — the label + input wrapper every labelled
//     field is built from.
//   * smoothTraversalFocus — animated Tab traversal.
//   * LabelledField / SpanField / ResponsiveGrid — the responsive grid every
//     section of the form lays its fields out on.
//   * SectionCard — the card chrome wrapping each logical section.
//
// Every other widget file under booking_view/widgets/ imports this one.

import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// The focus cue — the whole form's only one.
//
// Focus is shown by the focused control's own border and nothing else, so both
// of these are read by every field and every button. Change them here and the
// entire form follows.
// ---------------------------------------------------------------------------

/// Border colour of whichever control currently has focus.
const Color fieldFocusColor = Color(0xFF312E81);

/// Border width of a focused control. Deliberately heavier than Material's
/// own 2.0 focused outline — the cue has to carry the whole job of showing
/// where Tab has landed.
const double fieldFocusWidth = 2.5;

/// The focus border colour to draw on top of [background].
///
/// [fieldFocusColor] on anything light enough to show it. White on a dark
/// fill, because an indigo ring around a near-black button — or around the
/// indigo one that shares its colour exactly — reads as no ring at all.
///
/// The threshold splits the two groups this form actually uses, with room to
/// spare on both sides. Measured luminances: the dark fills are the update
/// form's near-black icon buttons (0.014) and the create form's indigo SAVE
/// (0.042); the lightest thing that still wants an indigo ring is the create
/// form's red CLEAR (0.161), then green (0.266), grey (0.509) and white.
Color focusRingOn(Color background) =>
    background.computeLuminance() < 0.10 ? Colors.white : fieldFocusColor;

/// Dense, form-friendly input styling shared by every field.
///
/// BookingFormScreen applies this itself rather than relying on the ambient
/// theme — without `isDense` Material forces a 48px minimum on every input and
/// the form roughly doubles in height.
///
/// `focusedBorder` is set explicitly; every other state is left to Material's
/// own defaults, so an idle field keeps its plain 1px outline. InputDecorator
/// merges this theme in itself (`InputDecoration.applyDefaults`), which is why
/// the date and time pickers pick the same focused border up without being
/// told about it.
const InputDecorationTheme denseInputTheme = InputDecorationTheme(
  isDense: true,
  contentPadding:
      EdgeInsets.symmetric(horizontal: 8, vertical: Density.fieldPadY),
  border: OutlineInputBorder(),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: fieldFocusColor, width: fieldFocusWidth),
  ),
  filled: true,
  fillColor: Colors.white,
  hintStyle: TextStyle(fontSize: Density.fieldFont),
);

// ---------------------------------------------------------------------------
// Vertical density — the single place to tune how tall the form gets.
// Everything that contributes height reads from here.
// ---------------------------------------------------------------------------
class Density {
  // Inner padding of every input. This is THE knob for field height:
  // rendered height is roughly 20 + 2 * fieldPadY (so 8 -> ~36px).
  static const double fieldPadY = 8;
  // A dense DropdownButton has a hard-coded 24px inner height, taller than a
  // 13px line of text, so it needs 2px less padding to match the text fields.
  static const double dropPadY = fieldPadY - 2;
  static const double fieldFont = 13; // text inside inputs
  static const double labelFont = 10; // the small caps labels
  static const double labelGap = 2; // label -> input, stacked mode
  static const double labelGapX = 6; // label -> input, inline mode
  static const double labelWidth = 86; // label column width, inline mode
  static const double gridSpacing = 6; // between fields (x and y)
  static const double cardPad = 8; // inside a SectionCard
  static const double cardGap = 6; // between SectionCards
}

// ---------------------------------------------------------------------------
// Breakpoints — tweak these to taste.
// ---------------------------------------------------------------------------
class Breakpoints {
  static const double tablet = 640; // >= this width -> at least 2 columns
  static const double desktop = 1024; // >= this width -> 4 columns

  /// >= this width -> labels sit to the LEFT of their field instead of above
  /// it, which removes a whole text line from every row.
  ///
  /// Deliberately above the desktop breakpoint: iPads land below it (portrait
  /// is <= 1024, landscape is 1080-1180 on every model but the 12.9" Pro), so
  /// they keep the taller but easier-to-read stacked layout. Lower this to
  /// 1024 if you want inline labels on iPad landscape too.
  static const double inlineLabel = 1200;

  /// Base column count for the current width.
  static int columns(double width) {
    if (width >= desktop) return 4;
    if (width >= tablet) return 2;
    return 1;
  }
}

// ---------------------------------------------------------------------------
// Carries the label-placement decision down to every field, so the choice is
// made ONCE from the real screen width instead of each field guessing from
// its own (narrow) column.
// ---------------------------------------------------------------------------
class FormLayout extends InheritedWidget {
  final bool inlineLabels;

  const FormLayout({
    super.key,
    required this.inlineLabels,
    required super.child,
  });

  static bool inlineOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<FormLayout>()?.inlineLabels ??
      false;

  @override
  bool updateShouldNotify(FormLayout oldWidget) =>
      oldWidget.inlineLabels != inlineLabels;
}

/// Puts [label] next to [child] on wide screens and above it otherwise.
/// Every labelled field in this form is built from it, so the two layouts
/// can never drift apart.
class FieldShell extends StatelessWidget {
  final String label;
  final Widget child;
  const FieldShell({super.key, required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    // An empty label means "this cell continues the row before it" — the
    // zone dropdowns and notes fields sitting to the right of PICK / DROP.
    // Inline, it claims no label column at all so it butts straight up
    // against the field it follows; stacked, it takes a spacer the height of
    // the labels beside it so the row still lines up.
    if (label.isEmpty) {
      if (FormLayout.inlineOf(context)) return child;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: Density.labelFont + Density.labelGap),
          child,
        ],
      );
    }
    if (FormLayout.inlineOf(context)) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Two lines allowed so long labels ('DROPOFF NOTES') wrap instead of
          // being ellipsised — still shorter than the input beside them, so
          // the row does not grow.
          SizedBox(
            width: Density.labelWidth,
            child: FieldLabel(label, maxLines: 2),
          ),
          const SizedBox(width: Density.labelGapX),
          Expanded(child: child),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FieldLabel(label),
        const SizedBox(height: Density.labelGap),
        child,
      ],
    );
  }
}

class FieldLabel extends StatelessWidget {
  final String text;
  final int maxLines;
  const FieldLabel(this.text, {super.key, this.maxLines = 1});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontSize: Density.labelFont,
        height: 1.1,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.4,
        color: Color(0xFF444444),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Keyboard traversal.
//
// Tab walks the form in visual order: every field, then the action buttons.
// [smoothTraversalFocus] animates the scroll that brings the next field into
// view, instead of Flutter's default instant jump.
//
// Focus is shown by the focused control's OWN BORDER and nothing else — no
// glow, no fill, no highlight behind the cell. Fields get it from
// [denseInputTheme]'s `focusedBorder`; the custom controls — the icon buttons,
// the pill buttons, the field-shaped buttons — draw their own from
// [fieldFocusColor] / [fieldFocusWidth], or from [focusRingOn] when they have
// a dark fill to sit on. Nothing should be added on top of that.
// ---------------------------------------------------------------------------

/// Same behaviour as Flutter's default traversal scroll — including only
/// scrolling when the target is actually off-screen — but animated.
void smoothTraversalFocus(
  FocusNode node, {
  ScrollPositionAlignmentPolicy? alignmentPolicy,
  double? alignment,
  Duration? duration,
  Curve? curve,
}) {
  FocusTraversalPolicy.defaultTraversalRequestFocusCallback(
    node,
    // Passed straight through: the policy sends keepVisibleAtEnd going
    // forward and keepVisibleAtStart going back, which is what stops an
    // already-visible field from being yanked to the edge of the viewport.
    alignmentPolicy: alignmentPolicy,
    alignment: alignment,
    duration: duration ?? const Duration(milliseconds: 200),
    curve: curve ?? Curves.easeOutCubic,
  );
}

// ---------------------------------------------------------------------------
// A field that knows how many base columns it wants to occupy.
// span is clamped to the available column count, so a span-2 field
// becomes full-width on a 1-column phone automatically.
// ---------------------------------------------------------------------------
/// A field that can tell the grid what it is called.
///
/// [ResponsiveGrid] keys each cell by this label, which is what lets a section
/// add or drop a field at runtime — the return fields on a ONE WAY booking —
/// without the fields after it inheriting the wrong State. Without a key,
/// children are matched by list position, so removing R/VEH would hand its
/// 'SALOON' selection to ACC and trip DropdownButton's one-item-per-value
/// assertion.
abstract interface class LabelledField {
  String get label;
}

class SpanField {
  final int span;
  final Widget child;
  double? widths;

  /// Identity of this cell, for the grid's key. Defaults to the child's label
  /// when it is a [LabelledField]; set it by hand for anything else that sits
  /// in a section whose field list can change.
  final Object? id;

  SpanField(this.child, {this.span = 1, this.widths, this.id});

  /// Null for a child with no identity — those still match by position, which
  /// is fine as long as they are not in a list that grows and shrinks.
  Key? get cellKey {
    if (id != null) return ValueKey(id);
    // Cast rather than promote: LabelledField is not a subtype of Widget, so
    // `is` alone leaves the static type as Widget.
    final field = child;
    if (field is LabelledField) {
      final label = (field as LabelledField).label;
      // Unlabeled cells share the empty string, so keying by it would put
      // duplicate keys in the same Wrap. Fall back to position for those.
      if (label.isNotEmpty) return ValueKey(label);
    }
    return null;
  }
}

/// Lays SpanField children out on a base grid of [columns] columns and
/// reflows them with a Wrap. Used for every logical section of the form.
class ResponsiveGrid extends StatelessWidget {
  final List<SpanField> children;
  final double spacing;
  final double runSpacing;

  /// Tab order of this grid's first field. Each following field takes the
  /// next number, so sections stay in order as long as their bases are
  /// spaced further apart than any section is long.
  final int orderBase;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.orderBase = 0,
    this.spacing = Density.gridSpacing,
    this.runSpacing = Density.gridSpacing,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns = Breakpoints.columns(width);
        // Width of one base column, after subtracting the gaps between them.
        final colWidth = (width - spacing * (columns - 1)) / columns;

        double widthForSpan(int span) {
          final s = span.clamp(1, columns);
          return colWidth * s + spacing * (s - 1);
        }

        return Wrap(
          spacing: spacing,
          runSpacing: runSpacing,
          children: [
            for (final (i, f) in children.indexed)
              SizedBox(
                // Keyed by the field, not by its slot, so a section can drop a
                // field without the ones after it picking up its State.
                key: f.cellKey,
                width: f.widths ?? widthForSpan(f.span),
                child: FocusTraversalOrder(
                  order: NumericFocusOrder((orderBase + i).toDouble()),
                  child: f.child,
                ),
              ),
          ],
        );
      },
    );
  }
}

class SectionCard extends StatelessWidget {
  final Widget child;
  const SectionCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: Density.cardGap),
      padding: const EdgeInsets.all(Density.cardPad),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: child,
    );
  }
}
