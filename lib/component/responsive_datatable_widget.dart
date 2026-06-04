import 'package:flutter/material.dart';
import '../component/color.dart';
import '../view/dashboard_view/booking_table.dart';

enum ColumnSizeType { small, medium, large, fixed }

class TableColumnConfig {
  final String title;
  final ColumnSizeType sizeType;
  final double? fixedWidth;
  final Function(String)? onChanged;
  final bool removeSearching;

  TableColumnConfig({
    required this.title,
    required this.sizeType,
    this.fixedWidth,
    this.onChanged,
    this.removeSearching = false,
  });
}

class ResponsiveDataTableWidget extends StatefulWidget {
  final double totalWidth;
  final List<TableColumnConfig> columnConfigs;
  final List<dynamic> items;
  final List<dynamic> Function(dynamic item, Map<String, double> widths) rowBuilder;

  const ResponsiveDataTableWidget({
    super.key,
    required this.totalWidth,
    required this.columnConfigs,
    required this.items,
    required this.rowBuilder,
  });

  @override
  State<ResponsiveDataTableWidget> createState() => _ResponsiveDataTableWidgetState();
}

class _ResponsiveDataTableWidgetState extends State<ResponsiveDataTableWidget> {
  @override
  Widget build(BuildContext context) {
    double fixedWidthTotal = 0;
    double totalParts = 0;

    for (var config in widget.columnConfigs) {
      if (config.sizeType == ColumnSizeType.fixed) {
        fixedWidthTotal += config.fixedWidth ?? 70.0;
      } else if (config.sizeType == ColumnSizeType.small) {
        totalParts += 5;
      } else if (config.sizeType == ColumnSizeType.medium) {
        totalParts += 8;
      } else if (config.sizeType == ColumnSizeType.large) {
        totalParts += 13;
      }
    }

    if (totalParts == 0) totalParts = 1;
    final double remainingWidth = widget.totalWidth - fixedWidthTotal - 35;

    Map<String, double> calculatedWidths = {};
    for (var config in widget.columnConfigs) {
      if (config.sizeType == ColumnSizeType.fixed) {
        calculatedWidths[config.title] = config.fixedWidth ?? 70.0;
      } else if (config.sizeType == ColumnSizeType.small) {
        calculatedWidths[config.title] = remainingWidth * (5 / totalParts);
      } else if (config.sizeType == ColumnSizeType.medium) {
        calculatedWidths[config.title] = remainingWidth * (8 / totalParts);
      } else if (config.sizeType == ColumnSizeType.large) {
        calculatedWidths[config.title] = remainingWidth * (13 / totalParts);
      }
    }

    return SizedBox(
      width: widget.totalWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DataTable(
            columnSpacing: 1.0,
            horizontalMargin: 2.0,
            headingRowColor: MaterialStateProperty.all(DynamicColors.secondaryClr),
            dataRowMinHeight: 40,
            dataRowMaxHeight: 52,
            headingTextStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 10.5),
            dataTextStyle: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700),
            border: TableBorder(
              horizontalInside: BorderSide(width: 0.5, color: Colors.grey.shade400),
              verticalInside: BorderSide(width: 0.5, color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(4),
              top: BorderSide(width: 1, color: DynamicColors.textClr.withOpacity(0.5)),
              left: BorderSide(width: 1, color: DynamicColors.textClr.withOpacity(0.5)),
              right: BorderSide(width: 1, color: DynamicColors.textClr.withOpacity(0.5)),
              bottom: BorderSide(width: 1, color: DynamicColors.textClr.withOpacity(0.5)),
            ),
            columns: widget.columnConfigs.map((config) {
              return buildHeaderWithSearch(
                widhtss: calculatedWidths[config.title]!,
                title: config.title,
                onChanged: config.onChanged,
                removeSearching: config.removeSearching,
              );
            }).toList(),
            rows: widget.items.map((item) {
              final rawCells = widget.rowBuilder(item, calculatedWidths);

              List<DataCell> dataCells = [];
              for (int i = 0; i < rawCells.length; i++) {
                final cellData = rawCells[i];
                final config = widget.columnConfigs[i];
                final cellWidth = calculatedWidths[config.title]!;

                if (cellData is String) {
                  dataCells.add(DataCell(
                    SizedBox(
                      width: cellWidth,
                      child: Text(
                        cellData,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700),
                      ),
                    ),
                  ));
                } else if (cellData is Widget) {
                  dataCells.add(DataCell(cellData));
                }
              }
              return DataRow(cells: dataCells);
            }).toList(),
          ),
        ],
      ),
    );
  }
}
