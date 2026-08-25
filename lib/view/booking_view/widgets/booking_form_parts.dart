// booking_form_parts.dart
//
// Small chrome widgets around the edges of the booking form: the section
// header title, the top tab strip, the ETA/fare stat strip, and the bottom
// row of action buttons. See create_new_booking_form.dart for how these fit
// into the wider form.

import 'package:flutter/material.dart';

import 'booking_form_layout.dart';

class HeaderTitle extends StatelessWidget {
  final String text;
  const HeaderTitle(this.text, {super.key});
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }
}

class TopTabs extends StatelessWidget {
  const TopTabs({super.key});
  @override
  Widget build(BuildContext context) {
    Widget tab(String key, String label, {bool active = false}) => Container(
          margin: const EdgeInsets.only(right: 6, bottom: 6),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: active ? const Color(0xFF312E81) : const Color(0xFFEDEDED),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: active ? Colors.white24 : Colors.black12,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(key,
                    style: TextStyle(
                        fontSize: 11,
                        color: active ? Colors.white : Colors.black87)),
              ),
              const SizedBox(width: 6),
              Text(label,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: active ? Colors.white : Colors.black87)),
            ],
          ),
        );

    return Align(
      alignment: Alignment.centerLeft,
      child: Wrap(
        children: [
          tab('F1', 'BASE ADDRESS'),
          tab('F2', 'BOOKING FORM', active: true),
          tab('F6', 'QUOTATION'),
        ],
      ),
    );
  }
}

/// One read-only figure in a [StatStrip] — ETA, distance, total fares.
class BookingStat {
  final IconData icon;
  final String label;

  /// Rendered bold after [label], so the number reads ahead of its caption.
  final String value;

  const BookingStat(this.icon, this.label, this.value);
}

/// The row of derived figures above the fare fields.
///
/// Defaults to the create form's four empty stats; the update form passes the
/// three the booking has actually been costed with.
class StatStrip extends StatelessWidget {
  final List<BookingStat> stats;

  static const List<BookingStat> _empty = [
    BookingStat(Icons.info_outline, 'ETA:', '0 M'),
    BookingStat(Icons.timer_outlined, 'TIME:', '0 M'),
    BookingStat(Icons.route, 'DISTANCE:', '0 M'),
    BookingStat(Icons.payments_outlined, 'T/FARES:', '£ 0'),
  ];

  const StatStrip({super.key, this.stats = _empty});

  @override
  Widget build(BuildContext context) {
    Widget stat(BookingStat s) => Padding(
          padding: const EdgeInsets.only(right: 16, bottom: 2),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(s.icon, size: 15, color: Colors.grey.shade700),
              const SizedBox(width: 4),
              Text(s.label,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF444444))),
              const SizedBox(width: 4),
              Text(s.value,
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w700)),
            ],
          ),
        );
    return Align(
      alignment: Alignment.centerLeft,
      child: Wrap(children: [for (final s in stats) stat(s)]),
    );
  }
}

class ActionButtons extends StatelessWidget {
  const ActionButtons({super.key});
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= Breakpoints.tablet;
        // 700+ keeps the buttons last in the tab order, after every field.
        final buttons = <Widget>[
          _btn(700, 'MULTI BOOKING [F8]', const Color(0xFFBDBDBD),
              Colors.black87),
          _btn(701, 'MULTI VEHICLE [F9]', const Color(0xFFBDBDBD),
              Colors.black87),
          _btn(702, 'CLEAR [F7]', const Color(0xFFD32F2F), Colors.white),
          _btn(703, 'SAVE [HOME]', const Color(0xFF312E81), Colors.white),
        ];
        return wide
            ? Row(
                children: [
                  for (final b in buttons)
                    Expanded(
                        child: Padding(
                            padding: const EdgeInsets.all(3), child: b)),
                ],
              )
            : Column(
                children: [
                  for (final b in buttons)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: SizedBox(width: double.infinity, child: b),
                    ),
                ],
              );
      },
    );
  }

  Widget _btn(int order, String label, Color bg, Color fg) =>
      FocusTraversalOrder(
        order: NumericFocusOrder(order.toDouble()),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: bg,
            foregroundColor: fg,
            padding: const EdgeInsets.symmetric(vertical: 10),
            minimumSize: const Size(0, 34),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          ).copyWith(
            // Focus shows as a border here too, like every field above —
            // resolved per state because styleFrom's `side` would draw on all
            // of them. focusRingOn picks the colour: these buttons are solid,
            // and SAVE is fieldFocusColor itself, so it takes a white ring
            // where the lighter ones take the indigo.
            side: WidgetStateProperty.resolveWith(
              (states) => states.contains(WidgetState.focused)
                  ? BorderSide(color: focusRingOn(bg), width: fieldFocusWidth)
                  : null,
            ),
          ),
          child: Text(label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        ),
      );
}
