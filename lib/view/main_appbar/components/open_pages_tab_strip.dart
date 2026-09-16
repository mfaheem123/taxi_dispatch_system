import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Model/selected_dropdown.dart';
import '../../../component/color.dart';
import '../../dashboard_view/Controller/dashboard_controller.dart';
import '../../dashboard_view/dashboard/defult_dashboard_view.dart';

/// The grey strip under the app bar: a home button plus one chip per open page.
///
/// Tapping a chip shows its page, the close icon drops it, and dropping the
/// last one falls back to the dashboard.
class OpenPagesTabStrip extends StatelessWidget {
  const OpenPagesTabStrip({super.key, required this.controller});

  final DashboardController controller;

  /// Clears the chip that is currently marked as shown, so a new one can take
  /// its place.
  void _deselectCurrentChip() {
    final index = controller.selectedMenuItems
        .indexWhere((element) => element.selectedItem == true);
    if (index != -1) {
      controller.selectedMenuItems[index].selectedItem = false;
    }
  }

  void _showDashboard() {
    _deselectCurrentChip();
    controller.currentPage.value = ByDefaultDashboard();
    controller.update();
  }

  void _showChip(SelectedDropdown item) {
    _deselectCurrentChip();
    item.selectedItem = true;
    if (item.category != null) {
      controller.currentPage.value = item.category;
    }
    controller.update();
  }

  void _closeChip(SelectedDropdown item) {
    // Closing the shown chip hands the page over to the last chip left; closing
    // the only chip leaves the dashboard behind.
    if (item.selectedItem == true && controller.selectedMenuItems.length > 1) {
      _deselectCurrentChip();
      controller.selectedMenuItems.remove(item);
      controller.selectedMenuItems.last.selectedItem = true;
      controller.currentPage.value = controller.selectedMenuItems.last.category;
    } else {
      controller.selectedMenuItems.remove(item);
      controller.currentPage.value = ByDefaultDashboard();
    }

    controller.update();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      color: Colors.grey.shade300,
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        children: [
          _HomeButton(onTap: _showDashboard),
          ...controller.selectedMenuItems.map(
            (item) => _OpenPageChip(
              item: item,
              onTap: () => _showChip(item),
              onClose: () => _closeChip(item),
            ),
          ),
        ],
      ),
    );
  }
}

/// The home button that takes the shell back to the dashboard.
class _HomeButton extends StatelessWidget {
  const _HomeButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: DynamicColors.primaryClr,
          border: Border.all(color: DynamicColors.textClr),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(
          Icons.home,
          color: DynamicColors.whiteClr,
        ),
      ),
    );
  }
}

/// One open page in the strip.
class _OpenPageChip extends StatelessWidget {
  const _OpenPageChip({
    required this.item,
    required this.onTap,
    required this.onClose,
  });

  final SelectedDropdown item;
  final VoidCallback onTap;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Chip(
        label: Text(
          item.title!,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: DynamicColors.textClr,
          ),
        ),
        backgroundColor: item.selectedItem == true
            ? DynamicColors.whiteClr
            : DynamicColors.gryClr,
        deleteIcon: Icon(
          Icons.close,
          color: DynamicColors.textClr,
          size: 18,
        ),
        onDeleted: onClose,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
