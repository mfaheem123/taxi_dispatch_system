


import 'package:flutter/material.dart';

import 'color.dart';

class DatatableWidget extends StatefulWidget {
  DatatableWidget({super.key, this.columns, this.totalRow,this.cells,this.rows});

  List<DataColumn>? columns;
  int? totalRow;
  List<DataCell>? cells;
  final List<DataRow>? rows;


  @override
  State<DatatableWidget> createState() => _DatatableWidgetState();
}

class _DatatableWidgetState extends State<DatatableWidget> {
  @override
  Widget build(BuildContext context) {
    return DataTable(
        columnSpacing: 10, // 👈 space between columns
        headingRowColor: MaterialStateProperty.all(DynamicColors.secondaryClr),
        dataRowMinHeight: 48,
        dataRowMaxHeight: 56,
        headingTextStyle: const TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 13,
        ),
        dataTextStyle: TextStyle(
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
            color: Colors.grey.shade400, // 👈 vertical lines added
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
        rows: widget.rows?? List.generate(widget.totalRow!, (index) {
          return DataRow(
            cells: widget.cells!,
          );
        })
    );
  }
}
