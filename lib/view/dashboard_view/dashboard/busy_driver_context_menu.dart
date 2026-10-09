import 'package:dashboard_new1/component/textStyle.dart';
import 'package:flutter/material.dart';

void showContextMenu(BuildContext context, Offset offset) {

  showMenu(
    context: context,
    position: RelativeRect.fromLTRB(offset.dx, offset.dy, offset.dx, offset.dy),
    color: Colors.white,
    elevation: 8,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    items: [
      _buildMenuItem(1, Icons.near_me_outlined, "TRACK"),
      _buildMenuItem(2, Icons.person_off_outlined, "SINBIN"),
      _buildMenuItem(3, Icons.refresh_rounded, "RECOVER"),
      _buildMenuItem(4, Icons.check_circle_outline, "COMPLETE"),
      _buildMenuItem(5, Icons.person_remove_outlined, "NO SHOW"),
      _buildMenuItem(6, Icons.signpost_outlined, "NO PICKUP"),
      _buildMenuItem(7, Icons.search_outlined, "VIEW JOB"),
      _buildMenuItem(8, Icons.logout_outlined, "LOGOUT"),
      _buildMenuItem(9, Icons.phone_in_talk_outlined, "CALL DRIVER"),
    ],
  );
}

// Helper Widget Item
PopupMenuItem _buildMenuItem(int value, IconData icon, String title) {
  return PopupMenuItem(
    value: value,
    height: 38,
    child: Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF1E293B)),
        const SizedBox(width: 10),
        Text(
          title,
          style: outFitRegular(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
      ],
    ),
  );
}