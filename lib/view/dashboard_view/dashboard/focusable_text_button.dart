


import 'dart:ui';

import 'package:flutter/material.dart';

Widget focusableTextButton(String label, VoidCallback onTap) {
  return Focus(
    child: Builder(
      builder: (context) {
        final bool isFocused = Focus.of(context).hasFocus;

        return GestureDetector(
          onTapDown: (_) {
            // Give focus to this widget when tapped
            FocusScope.of(context).requestFocus(Focus.of(context));
          },
          onTap: onTap,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 6),
            decoration: BoxDecoration(
              color: isFocused ? Colors.blue : const Color(0xFF43489A),
              borderRadius: BorderRadius.circular(3),
            ),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    ),
  );
}