// import 'package:flutter/material.dart';
// import 'package:number_pagination/number_pagination.dart';
//
//
// class PaginationWidget extends StatelessWidget {
//   final int currentPage;
//   final int totalPages;
//   final Function(int) onPageChange;
//
//   const PaginationWidget({
//     super.key,
//     required this.currentPage,
//     required this.totalPages,
//     required this.onPageChange,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: NumberPagination(
//         onPageChanged: (page) {
//           onPageChange(page);
//         },
//         totalPages: totalPages,
//         currentPage: currentPage,
//         visiblePagesCount: 4,
//       ),
//     );
//   }
// }


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

        buttonElevation: 0,
        controlButtonColor: Colors.white,
        controlButtonSize: const Size(90, 40),


        firstPageIcon: const Icon(Icons.first_page, color: Colors.black, size: 20),
        lastPageIcon: const Icon(Icons.last_page, color: Colors.black, size: 20),

        previousPageIcon: const Center(
          child: Text('Previous',
            style: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ),
        nextPageIcon: const Center(
          child: Text('Next',
            style: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w500),
          ),
        ),

        selectedButtonColor: Colors.black,
        unSelectedButtonColor: Colors.white,
      ),
    );
  }
}