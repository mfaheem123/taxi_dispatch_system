import 'package:flutter/material.dart';
import 'package:number_pagination/number_pagination.dart';


class PaginationWidget extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final Function(int) onPageChange;

  const PaginationWidget({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: NumberPagination(
        onPageChanged: (page) {
          onPageChange(page); 
        },
        totalPages: totalPages,
        currentPage: currentPage,
        visiblePagesCount: 4,
      ),
    );
  }
}


