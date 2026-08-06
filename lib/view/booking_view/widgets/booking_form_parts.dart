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

class StatStrip extends StatelessWidget {
  const StatStrip({super.key});
  @override
  Widget build(BuildContext context) {
    Widget stat(IconData icon, String label) => Padding(
          padding: const EdgeInsets.only(right: 16, bottom: 2),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 15, color: Colors.grey.shade700),
              const SizedBox(width: 4),
              Text(label, style: const TextStyle(fontSize: 12)),
            ],
          ),
        );
    return Align(
      alignment: Alignment.centerLeft,
      child: Wrap(
        children: [
          stat(Icons.info_outline, 'ETA: 0 M'),
          stat(Icons.timer_outlined, 'TIME: 0 M'),
          stat(Icons.route, 'DISTANCE: 0 M'),
          stat(Icons.payments_outlined, 'T/FARES: £ 0'),
        ],
      ),
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
        child: FocusRing(
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: bg,
              foregroundColor: fg,
              padding: const EdgeInsets.symmetric(vertical: 10),
              minimumSize: const Size(0, 34),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
            ),
            child: Text(label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          ),
        ),
      );
}
