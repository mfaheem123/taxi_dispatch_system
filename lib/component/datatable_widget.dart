


import 'package:flutter/material.dart';

import 'color.dart';

// class DatatableWidget extends StatefulWidget {
//   DatatableWidget({super.key, this.columns, this.totalRow,this.cells,this.rows});
//
//   List<DataColumn>? columns;
//   int? totalRow;
//   List<DataCell>? cells;
//   final List<DataRow>? rows;
//
//
//   @override
//   State<DatatableWidget> createState() => _DatatableWidgetState();
// }


// class _DatatableWidgetState extends State<DatatableWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return DataTable(
//         columnSpacing: 10, // 👈 space between columns
//         headingRowColor: MaterialStateProperty.all(DynamicColors.secondaryClr),
//         dataRowMinHeight: 48,
//         dataRowMaxHeight: 56,
//         headingTextStyle: const TextStyle(
//           fontWeight: FontWeight.w800,
//           fontSize: 13,
//         ),
//         dataTextStyle: TextStyle(
//           fontSize: 13,
//           fontWeight: FontWeight.w800,
//         ),
//         border: TableBorder(
//           horizontalInside: BorderSide(
//             width: 0.5,
//             color: Colors.grey.shade400,
//           ),
//           verticalInside: BorderSide(
//             width: 0.5,
//             color: Colors.grey.shade400, // 👈 vertical lines added
//           ),
//           borderRadius: BorderRadius.circular(4),
//           top: BorderSide(
//             width: 1,
//             color: DynamicColors.textClr.withOpacity(0.5),
//           ),
//           left: BorderSide(
//             width: 1,
//             color: DynamicColors.textClr.withOpacity(0.5),
//           ),
//           right: BorderSide(
//             width: 1,
//             color: DynamicColors.textClr.withOpacity(0.5),
//           ),
//           bottom: BorderSide(
//             width: 1,
//             color: DynamicColors.textClr.withOpacity(0.5),
//           ),
//         ),
//         columns: widget.columns!,
//         rows: widget.rows?? List.generate(widget.totalRow!, (index) {
//           return DataRow(
//             cells: widget.cells!,
//           );
//         })
//     );
//   }
// }

class DatatableWidget extends StatefulWidget {
  DatatableWidget({
    super.key,
    this.columns,
    this.totalRow,
    this.cells,
    this.rows,
    this.columnSpacing,
    this.horizontalMargin,
    this.headingRowHeight,
    this.dataRowMinHeight,
    this.dataRowMaxHeight,
  });

  final List<DataColumn>? columns;
  final int? totalRow;
  final List<DataCell>? cells;
  final List<DataRow>? rows;

  // ── Custom Sizing Properties ──
  final double? columnSpacing;
  final double? horizontalMargin;
  final double? headingRowHeight;
  final double? dataRowMinHeight;
  final double? dataRowMaxHeight;

  @override
  State<DatatableWidget> createState() => _DatatableWidgetState();
}

class _DatatableWidgetState extends State<DatatableWidget> {
  @override
  Widget build(BuildContext context) {
    return DataTable(
      columnSpacing: widget.columnSpacing ?? 10, // 👈 Configurable column spacing
      horizontalMargin: widget.horizontalMargin ?? 12, // 👈 Outer margin control
      headingRowHeight: widget.headingRowHeight ?? 48,
      dataRowMinHeight: widget.dataRowMinHeight ?? 48,
      dataRowMaxHeight: widget.dataRowMaxHeight ?? 56,
      headingRowColor: WidgetStateProperty.all(DynamicColors.secondaryClr),
      headingTextStyle: const TextStyle(
        fontWeight: FontWeight.w800,
        fontSize: 13,
      ),
      dataTextStyle: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w800,
      ),
      border: TableBorder(
        horizontalInside: BorderSide(
          width: 0.5,
          color: Colors.grey.shade400,
        ),
        verticalInside: BorderSide(
          width: 0.5,
          color: Colors.grey.shade400,
        ),
        borderRadius: BorderRadius.circular(4),
        top: BorderSide(
          width: 1,
          color: DynamicColors.textClr.withOpacity(0.5),
        ),
        left: BorderSide(
          width: 1,
          color: DynamicColors.textClr.withOpacity(0.5),
        ),
        right: BorderSide(
          width: 1,
          color: DynamicColors.textClr.withOpacity(0.5),
        ),
        bottom: BorderSide(
          width: 1,
          color: DynamicColors.textClr.withOpacity(0.5),
        ),
      ),
      columns: widget.columns!,
      rows: widget.rows ??
          List.generate(widget.totalRow!, (index) {
            return DataRow(
              cells: widget.cells!,
            );
          }),
    );
  }
}