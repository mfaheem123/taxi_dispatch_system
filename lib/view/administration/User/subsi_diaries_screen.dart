import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/customButton.dart';
import 'package:dashboard_new1/component/datatable_widget.dart';
import 'package:dashboard_new1/component/pagination.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:dashboard_new1/view/administration/controller/administration_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../component/networks/api.dart';
import '../../dashboard_view/Controller/dashboard_controller.dart';
import '../../dashboard_view/booking_table.dart';
import 'create_subsiDiary.dart';

class SubsiDiariesScreen extends StatefulWidget {
  const SubsiDiariesScreen({super.key});

  @override
  State<SubsiDiariesScreen> createState() => _SubsiDiariesScreenState();
}

class _SubsiDiariesScreenState extends State<SubsiDiariesScreen> {
  final AdministrationController controller =
      Get.isRegistered<AdministrationController>()
          ? Get.find<AdministrationController>()
          : Get.put(AdministrationController());
  final DashboardController _controller = Get.find();

  @override
  void initState() {
    super.initState();
    shortCutKeyValue.value = "SubsiDiariesScreen";
  }

  List permissions = [];


  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdministrationController>(
      initState: (state) {
          permissions = Api().sp.read('all_permissions') ?? [];
        controller.listSubsDiary();
      },
      builder: (controller) {
        // ✅ Null-safe list
        final List listToShow = controller.filteredSubsiDiary.isNotEmpty
            ? controller.filteredSubsiDiary
            : (controller.subsiDiaryAll ?? []);

        // ✅ Loading State
        if (controller.subsDiaryLoading == true) {
          return const Center(child: CircularProgressIndicator());
        }

        // ✅ Empty State
        if (listToShow.isEmpty) {
          return const Center(
            child: Text(
              "No Data Found",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
            ),
          );
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            final bool isMobile = constraints.maxWidth < 600;
            final bool isTablet =
                constraints.maxWidth >= 600 && constraints.maxWidth < 1024;

            return Wrap(
              runSpacing: 10,
              spacing: 10,
              children: [
                /// 🔹 Header
                Container(
                  width: Get.width,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  color: DynamicColors.gryClr.withOpacity(0.5),
                  child: Row(
                    children: [
                      Text(
                        "SUBSIDIARIES" +
                            " (${controller.subsDiaryModel!.count.toString()})",
                        style: mozillaTextSemiBoldText(
                            fontWeight: FontWeight.w800, fontSize: 17),
                      ),
                      const Spacer(),
                      CustomButton(
                        onTap: controller.listSubsDiary,
                        height: 40,
                        width: 80,
                        borderRadius: 4,
                        widget: const Icon(
                          Icons.refresh,
                          color: Colors.white,
                          size: 25,
                        ),
                      ),
                    ],
                  ),
                ),

                /// 🔹 Table
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: isMobile || isTablet ? Get.width + 700 : Get.width,
                    child: DatatableWidget(
                      columns: [
                        // DataColumn(
                        //   label:  Checkbox(
                        //     value: controller.selectedSubsDiaryIds.length == listToShow.length,
                        //     onChanged: (v) {
                        //       if (v == true) {
                        //         controller.selectedSubsDiaryIds
                        //             .addAll(listToShow.map((e) => e.id));
                        //       } else {
                        //         controller.selectedSubsDiaryIds.clear();
                        //       }
                        //       controller.update();
                        //     },
                        //   ),
                        //
                        // ),
                        buildHeaderWithSearch(
                          title: "NAME",
                          onChanged: (v) {
                            controller.searchSubsiDiaryName.value = v;
                            controller.subsiDiarySearchChanged();
                          },
                        ),
                        buildHeaderWithSearch(
                          title: "EMAIL",
                          onChanged: (v) {
                            controller.searchSubsiDiaryEmail.value = v;
                            controller.subsiDiarySearchChanged();
                          },
                        ),
                        buildHeaderWithSearch(
                          title: "TELEPHONE",
                          onChanged: (v) {
                            controller.searchSubsiDiaryTelephone.value = v;
                            controller.subsiDiarySearchChanged();
                          },
                        ),
                        buildHeaderWithSearch(
                          title: "ADDRESS",
                          onChanged: (v) {
                            controller.searchSubsiDiaryAddress.value = v;
                            controller.subsiDiarySearchChanged();
                          },
                        ),
                        buildHeaderWithSearch(
                          title: "FAX",
                          onChanged: (v) {
                            controller.searchSibsiDiaryFax.value = v;
                            controller.subsiDiarySearchChanged();
                          },
                        ),
                        buildHeaderWithSearch(
                          title: "ACTIONS",
                          removeSearching: true,
                        ),
                      ],

                      /// ✅ Safe total rows
                      totalRow: listToShow.length,

                      /// ✅ Safe rows mapping
                      rows: listToShow.map<DataRow>((item) {
                        return DataRow(
                          cells: [
                            // DataCell(
                            //   Checkbox(
                            //     value: controller.selectedSubsDiaryIds.contains(item.id),
                            //     onChanged: (v) {
                            //       if (v == true) {
                            //         controller.selectedSubsDiaryIds.add(item.id);
                            //       } else {
                            //         controller.selectedSubsDiaryIds.remove(item.id);
                            //       }
                            //       controller.update();
                            //     },
                            //   ),
                            // ),

                            /// 🔥 Null Safe Fields
                            DataCell(Center(child: Text((item.name ?? "-").toUpperCase()))),
                            DataCell(Center(child: Text((item.email ?? "-").toUpperCase()))),
                            DataCell(Center(
                                child: Text(item.telephoneNumber ?? "-"))),
                            DataCell(Center(child: Text((item.address ?? "-").toUpperCase()))),
                            DataCell(Center(child: Text((item.fax ?? "-").toUpperCase()))),

                            /// Actions
                            DataCell(
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit_calendar,
                                        color: DynamicColors.primaryClr),
                                    onPressed: () {
                                      if(permissions.contains('update_subsidiary')){
                                        controller.subsidiaryUpdate(data: item);

                                        controller.isSubsiDiaryUpdating.value =
                                        true;

                                        int index = _controller.selectedMenuItems
                                            .indexWhere((element) =>
                                        element.title ==
                                            "CREATE SUBSIDIARY");
                                        if (index != -1) {
                                          _controller.selectedMenuItems[index]
                                              .selectedItem = true;
                                        } else {
                                          _controller.menuBarRefresh(
                                              title: "CREATE SUBSIDIARY",
                                              pageName: CreateSubsiDiary());
                                        }
                                        // Page switch karein
                                        _controller.currentPage.value =
                                            CreateSubsiDiary();
                                        controller.update();
                                      }

                                    },
                                  ),
                                  Text("|"),
                                  IconButton(
                                    icon: Icon(Icons.delete,
                                        color: DynamicColors.redClr),
                                    onPressed: () {

            if(permissions.contains('delete_subsidiary')){
              controller.subsidiariesDelete(item.id);
            }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),

                /// 🔹 Pagination
                PaginationWidget(
                  currentPage: controller.subsiCurrentPage.value ?? 1,
                  totalPages: controller.subsiTotalPages.value ?? 1,
                  onPageChange: controller.onPageChange,
                ),
              ],
            );
          },
        );
      },
    );
  }
}
