import 'package:dashboard_new1/component/action_icon_button.dart';
import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:timepickerfield/timepickerfield.dart';
import '../../alert/account_details_alert.dart';
import '../../alert/multi_booking_alert.dart';
import '../../component/dropdown_button.dart';
import '../../component/responsive_datatable_widget.dart';

class MultiReservationScreen extends StatefulWidget {
  const MultiReservationScreen({super.key});

  @override
  State<MultiReservationScreen> createState() => _MultiReservationScreenState();
}

class _MultiReservationScreenState extends State<MultiReservationScreen> {
  TimeOfDay? selectedTime;

  bool isAllSelected = false;
  Set<int> selectedRowIndices = {};
  bool isQuotationSelected = false;

  static const Color _border = Color(0xFFE1E7F0);
  static const Color _fieldFill = Color(0xFFF2F5F9);
  static const Color _subtleText = Color(0xFF475569);

  static const double _fsLabel = 11.0;
  static const double _fieldHeight = 34.0;

  int selectedRowIndex = 0;

  // Controllers
  final TextEditingController pickController = TextEditingController();
  final TextEditingController dropController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobController = TextEditingController();
  final TextEditingController telController = TextEditingController();
  final TextEditingController fareController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController leadController = TextEditingController();

  // ---------------------------------------------------------------------------
  // STATIC DROPDOWN DATA LISTS
  // ---------------------------------------------------------------------------
  final List<String> pickZoneList = ['Zone A', 'Zone B', 'Zone C', 'Zone D'];
  final List<String> dropZoneList = ['Zone A', 'Zone B', 'Zone C', 'Zone D'];
  final List<String> jourList = ['R/N', 'O/W', 'WAIT & RETURN'];
  final List<String> vehList = ['Saloon', 'Estate', 'MPV', 'Exec'];
  final List<String> accList = ['Account 1', 'Account 2', 'Account 3'];
  final List<String> deptList = ['Dept A', 'Dept B', 'Dept C'];
  final List<String> escList = ['Escort 1', 'Escort 2'];
  final List<String> payList = ['ACCOUNT', 'CASH', 'CARD'];
  final List<String> driverList = ['Driver 101', 'Driver 102', 'Driver 103'];

  // Selected State Values
  String? selectedPickZone;
  String? selectedDropZone;
  String? selectedJour = 'R/N';
  String? selectedVeh;
  String? selectedAcc;
  String? selectedDept;
  String? selectedEsc;
  String? selectedPay = 'ACCOUNT';
  String? selectedDriver;

  final List<Map<String, String>> reservations = [
    {'datetime': 'MON 05-10-26 09:00', 'ref': 'NTG75891', 'jt': 'R/N'},
    {'datetime': 'WED 07-10-26 09:00', 'ref': 'NTG75892', 'jt': 'R/N'},
    {'datetime': 'FRI 09-10-26 09:00', 'ref': 'NTG75881', 'jt': 'R/N'},
    {'datetime': 'MON 12-10-26 09:00', 'ref': 'NTG75893', 'jt': 'R/N'},
    {'datetime': 'WED 14-10-26 09:00', 'ref': 'NTG75894', 'jt': 'R/N'},
    {'datetime': 'FRI 16-10-26 09:00', 'ref': 'NTG75895', 'jt': 'R/N'},
    {'datetime': 'MON 19-10-26 09:00', 'ref': 'NTG75896', 'jt': 'R/N'},
    {'datetime': 'WED 21-10-26 09:00', 'ref': 'NTG75897', 'jt': 'R/N'},
    {'datetime': 'FRI 23-10-26 09:00', 'ref': 'NTG75898', 'jt': 'R/N'},
    {'datetime': 'MON 26-10-26 09:00', 'ref': 'NTG75899', 'jt': 'R/N'},
    {'datetime': 'WED 28-10-26 09:00', 'ref': 'NTG75900', 'jt': 'R/N'},
    {'datetime': 'FRI 30-10-26 09:00', 'ref': 'NTG75901', 'jt': 'R/N'},
    {'datetime': 'MON 05-10-26 18:10', 'ref': 'NTG75891', 'jt': 'R/N'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: FocusTraversalGroup(
          policy: WidgetOrderTraversalPolicy(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                bool isScreenMobile = constraints.maxWidth < 850;

                return isScreenMobile
                    ? Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: _buildLeftTableSection(),
                          ),
                          const SizedBox(height: 16),
                          _buildRightFormSection(),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 390,
                            child: _buildLeftTableSection(),
                          ),
                          Expanded(
                            child: _buildRightFormSection(),
                          ),
                        ],
                      );
              },
            ),
          ),
        ));
  }

  // ────────── Left Table Section Widget ──────────
  Widget _buildLeftTableSection() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(right: BorderSide(color: _border, width: 1)),
      ),
      child: ResponsiveDataTableWidget(
        totalWidth: 390,
        headerBackgroundColor: Colors.grey.shade200,
        columnConfigs: [
          TableColumnConfig(
            title: "CHECKBOX",
            sizeType: ColumnSizeType.fixed,
            fixedWidth: 32.0,
            removeSearching: true,
            customHeader: Center(
              child: Focus(
                onKeyEvent: (node, event) {
                  if (event is KeyDownEvent &&
                      (event.logicalKey == LogicalKeyboardKey.enter ||
                          event.logicalKey == LogicalKeyboardKey.space)) {
                    setState(() {
                      isAllSelected = !isAllSelected;
                      if (isAllSelected) {
                        selectedRowIndices = Set.from(
                            List.generate(reservations.length, (i) => i));
                      } else {
                        selectedRowIndices.clear();
                      }
                    });
                    return KeyEventResult.handled;
                  }
                  return KeyEventResult.ignored;
                },
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: Checkbox(
                    value: isAllSelected,
                    activeColor: DynamicColors.primaryClr,
                    onChanged: (val) {
                      setState(() {
                        isAllSelected = val ?? false;
                        if (isAllSelected) {
                          selectedRowIndices = Set.from(
                              List.generate(reservations.length, (i) => i));
                        } else {
                          selectedRowIndices.clear();
                        }
                      });
                    },
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ),
            ),
          ),
          TableColumnConfig(title: "DATETIME", sizeType: ColumnSizeType.large),
          TableColumnConfig(title: "REF #", sizeType: ColumnSizeType.medium),
          TableColumnConfig(title: "J/T", sizeType: ColumnSizeType.small),
          TableColumnConfig(title: "ACTION", sizeType: ColumnSizeType.fixed, fixedWidth: 36.0, removeSearching: true),
        ],
        items: reservations,
        rowBuilder: (item, widths) {
          final index = reservations.indexOf(item);
          final bool isRowSelected = selectedRowIndices.contains(index);

          return [
            Center(
              child: SizedBox(
                width: widths["CHECKBOX"],
                child: Focus(
                  onKeyEvent: (node, event) {
                    if (event is KeyDownEvent &&
                        (event.logicalKey == LogicalKeyboardKey.enter ||
                            event.logicalKey == LogicalKeyboardKey.space)) {
                      setState(() {
                        if (isRowSelected) {
                          selectedRowIndices.remove(index);
                          isAllSelected = false;
                        } else {
                          selectedRowIndices.add(index);
                          if (selectedRowIndices.length ==
                              reservations.length) {
                            isAllSelected = true;
                          }
                        }
                      });
                      return KeyEventResult.handled;
                    }
                    return KeyEventResult.ignored;
                  },
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: Checkbox(
                      value: isRowSelected,
                      activeColor: DynamicColors.primaryClr,
                      onChanged: (val) {
                        setState(() {
                          if (val == true) {
                            selectedRowIndices.add(index);
                            if (selectedRowIndices.length ==
                                reservations.length) {
                              isAllSelected = true;
                            }
                          } else {
                            selectedRowIndices.remove(index);
                            isAllSelected = false;
                          }
                        });
                      },
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ),
              ),
            ),
            Center(child: Text(item['datetime']!,
                    style: outFitRegular(fontSize: 12, fontWeight: FontWeight.w600, color: const Color(0xFF1E293B)))),
            Center(child: Text(item['ref']!,
                    style: outFitRegular(fontSize: 12, color: const Color(0xFF1E293B)))),
            Center(child: Text(item['jt']!,
                    style: outFitRegular(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF1E293B)))),
            Center(child: SizedBox(
                width: widths["ACTION"],
                child: ActionIconButton(
                  icon: Icons.visibility_outlined,
                  size: 16,
                  color: const Color(0xFF16A34A),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => MultiReservationAlert(item: item),
                    );
                  },
                ),
              ),
            ),
          ];
        },
      ),
    );
  }

  // ────────── Right Form Section Widget ──────────
  Widget _buildRightFormSection() {
    return FocusTraversalGroup(
        policy: OrderedTraversalPolicy(),
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isFormMobile = constraints.maxWidth < 650;

            return Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Text('USER : ', style: outFitRegular(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade700)),
                      Text('NADEEM', style: outFitRegular(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red)),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // 1. Main Form Fields Container
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: _border),
                    ),
                    child: Column(
                      children: [
                        _buildLocationRow('PICK', pickController, 'PICKUP NOTES', LucideIcons.arrowDownUp,
                            selectedPickZone, pickZoneList, (val) => setState(() => selectedPickZone = val)),
                        const SizedBox(height: 8),
                        _buildLocationRow('DROP', dropController, 'DROPOFF NOTES', LucideIcons.route,
                            selectedDropZone, dropZoneList, (val) => setState(() => selectedDropZone = val)),
                        const SizedBox(height: 10),

                        // Name, Email, Mob, Tel (Responsive)
                        isFormMobile
                            ? Column(
                                children: [
                                  _labelledField('NAME',
                                      TextField(controller: nameController, style: _valStyle, decoration: _fieldDec(suffix: Icons.search))),
                                  const SizedBox(height: 8),
                                  _labelledField('EMAIL',
                                      TextField(controller: emailController, style: _valStyle, decoration: _fieldDec())),
                                  const SizedBox(height: 8),
                                  _labelledField('MOB',
                                      TextField(controller: mobController, style: _valStyle, decoration: _fieldDec(suffix: Icons.search))),
                                  const SizedBox(height: 8),
                                  _labelledField('TEL',
                                      TextField(controller: telController, style: _valStyle, decoration: _fieldDec(suffix: Icons.search))),
                                ],
                              )
                            : Row(
                                children: [
                                  Expanded(
                                      flex: 3,
                                      child: _labelledField('NAME',
                                          TextField(controller: nameController, style: _valStyle, decoration: _fieldDec(suffix: Icons.search)))),
                                  const SizedBox(width: 8),
                                  Expanded(
                                      flex: 3,
                                      child: _labelledField('EMAIL',
                                          TextField(controller: emailController, style: _valStyle, decoration: _fieldDec()))),
                                  const SizedBox(width: 8),
                                  Expanded(
                                      flex: 3,
                                      child: _labelledField('MOB',
                                          TextField(controller: mobController, style: _valStyle, decoration: _fieldDec(suffix: Icons.search)))),
                                  const SizedBox(width: 8),
                                  Expanded(
                                      flex: 3,
                                      child: _labelledField('TEL',
                                          TextField(controller: telController, style: _valStyle, decoration: _fieldDec(suffix: Icons.search)))),
                                ],
                              ),
                        const SizedBox(height: 10),

                        // Date & Time (Responsive)
                        isFormMobile
                            ? Column(
                                children: [
                                  _labelledField('DATE', _dateBox()),
                                  const SizedBox(height: 8),
                                  _labelledField('TIME', _timePickerBox()),
                                ],
                              )
                            : Row(
                                children: [
                                  Expanded(
                                      child: _labelledField('DATE', SizedBox(height: _fieldHeight, child: _dateBox()))),
                                  const SizedBox(width: 8),
                                  Expanded(
                                      child: _labelledField('TIME', SizedBox(height: _fieldHeight, child: _timePickerBox()))),
                                  const SizedBox(width: 8),
                                  const Expanded(child: SizedBox()),
                                  const SizedBox(width: 8),
                                  const Expanded(child: SizedBox()),
                                ],
                              ),
                        const SizedBox(height: 10),

                        // Lead, Jour, Veh (Responsive)
                        isFormMobile
                            ? Column(
                                children: [
                                  _labelledField('LEAD', _timePickerBox()),
                                  const SizedBox(height: 8),
                                  _labelledField('JOUR',
                                    _dropdown<String>(
                                      value: selectedJour,
                                      hint: 'SELECT JOUR',
                                      items: jourList,
                                      label: (item) => item,
                                      onChanged: (val) =>
                                          setState(() => selectedJour = val),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  _labelledField('VEH',
                                    _dropdown<String>(
                                      value: selectedVeh,
                                      hint: 'SELECT VEHICLE',
                                      items: vehList,
                                      label: (item) => item,
                                      onChanged: (val) =>
                                          setState(() => selectedVeh = val),
                                    ),
                                  ),
                                ],
                              )
                            : Row(
                                children: [
                                  Expanded(
                                      child: _labelledField('LEAD', SizedBox(height: _fieldHeight, child: _timePickerBox()))),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: _labelledField('JOUR',
                                      SizedBox(height: _fieldHeight,
                                        child: _dropdown<String>(
                                          height: _fieldHeight,
                                          value: selectedJour,
                                          hint: 'SELECT JOUR',
                                          items: jourList,
                                          label: (item) => item,
                                          onChanged: (val) => setState(
                                              () => selectedJour = val),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: _labelledField('VEH',
                                      SizedBox(
                                        height: _fieldHeight,
                                        child: _dropdown<String>(
                                          height: _fieldHeight,
                                          value: selectedVeh,
                                          hint: 'SELECT VEHICLE',
                                          items: vehList,
                                          label: (item) => item,
                                          onChanged: (val) =>
                                              setState(() => selectedVeh = val),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Expanded(child: SizedBox()),
                                ],
                              ),
                        const SizedBox(height: 10),

                        // Acc, Pass, Lugg, Slgg (Responsive)
                        isFormMobile
                            ? Column(
                                children: [
                                  _labelledField('ACC',
                                    _dropdown<String>(
                                      value: selectedAcc,
                                      hint: 'SELECT ACCOUNT',
                                      items: accList,
                                      label: (item) => item,
                                      onChanged: (val) =>
                                          setState(() => selectedAcc = val),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  _labelledField('PASS', TextField(style: _valStyle, decoration: _fieldDec())),
                                  const SizedBox(height: 8),
                                  _labelledField('LUGG', TextField(style: _valStyle, decoration: _fieldDec())),
                                  const SizedBox(height: 8),
                                  _labelledField('SLGG', TextField(style: _valStyle, decoration: _fieldDec())),
                                ],
                              )
                            : Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: _labelledField('ACC',
                                      _dropdown<String>(
                                        height: _fieldHeight,
                                        value: selectedAcc,
                                        hint: 'SELECT ACCOUNT',
                                        items: accList,
                                        label: (item) => item,
                                        onChanged: (val) =>
                                            setState(() => selectedAcc = val),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                      flex: 3,
                                      child: _labelledField('PASS', TextField(style: _valStyle, decoration: _fieldDec()))),
                                  const SizedBox(width: 8),
                                  Expanded(
                                      flex: 3,
                                      child: _labelledField('LUGG', TextField(style: _valStyle, decoration: _fieldDec()))),
                                  const SizedBox(width: 8),
                                  Expanded(
                                      flex: 3,
                                      child: _labelledField('SLGG', TextField(style: _valStyle, decoration: _fieldDec()))),
                                ],
                              ),
                        const SizedBox(height: 10),
                        isFormMobile
                            ? Column(
                                children: [
                                  _labelledField('DEPT',
                                    _dropdown<String>(
                                      value: selectedDept,
                                      hint: 'SELECT DEPT',
                                      items: deptList,
                                      label: (item) => item,
                                      onChanged: (val) =>
                                          setState(() => selectedDept = val),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  _labelledField('ESC',
                                    _dropdown<String>(
                                      value: selectedEsc,
                                      hint: 'SELECT ESC',
                                      items: escList,
                                      label: (item) => item,
                                      onChanged: (val) =>
                                          setState(() => selectedEsc = val),
                                    ),
                                  ),
                                ],
                              )
                            : Row(
                                children: [
                                  Expanded(
                                    child: _labelledField('DEPT',
                                      _dropdown<String>(
                                        height: _fieldHeight,
                                        value: selectedDept,
                                        hint: 'SELECT DEPT',
                                        items: deptList,
                                        label: (item) => item,
                                        onChanged: (val) =>
                                            setState(() => selectedDept = val),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: _labelledField('ESC',
                                      _dropdown<String>(
                                        height: _fieldHeight,
                                        value: selectedEsc,
                                        hint: 'SELECT ESC',
                                        items: escList,
                                        label: (item) => item,
                                        onChanged: (val) =>
                                            setState(() => selectedEsc = val),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Expanded(child: SizedBox()),
                                  const SizedBox(width: 8),
                                  const Expanded(child: SizedBox()),
                                ],
                              ),
                        const SizedBox(height: 10),

                        // Pay, Quotation, Icons (Responsive)
                        isFormMobile
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  _labelledField('PAY',
                                    _dropdown<String>(
                                      value: selectedPay,
                                      hint: 'ACCOUNT',
                                      items: payList,
                                      label: (item) => item,
                                      onChanged: (val) =>
                                          setState(() => selectedPay = val),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Focus(
                                        onKeyEvent: (node, event) {
                                          if (event is KeyDownEvent &&
                                              (event.logicalKey ==
                                                      LogicalKeyboardKey.enter ||
                                                  event.logicalKey ==
                                                      LogicalKeyboardKey.space)) {
                                            setState(() {
                                              isQuotationSelected =
                                                  !isQuotationSelected;
                                            });
                                            return KeyEventResult.handled;
                                          }
                                          return KeyEventResult.ignored;
                                        },
                                        child: SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: Checkbox(
                                            value: isQuotationSelected,
                                            activeColor: DynamicColors.primaryClr,
                                            onChanged: (val) {
                                              setState(() {
                                                isQuotationSelected =
                                                    val ?? false;
                                              });
                                            },
                                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Text('QUOTATION', style: outFitRegular(fontSize: 12, fontWeight: FontWeight.w700)),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    height: 32,
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: _border),
                                      borderRadius: BorderRadius.circular(4),
                                      color: _fieldFill,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                                Icons.shopping_cart_outlined,
                                                size: 14,
                                                color: _subtleText),
                                            const SizedBox(width: 3),
                                            Text('( )', style: outFitRegular(fontSize: 11, fontWeight: FontWeight.bold)),
                                          ],
                                        ),
                                        Text('£', style: outFitRegular(fontSize: 12, fontWeight: FontWeight.bold)),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                                Icons.sticky_note_2_outlined,
                                                size: 14,
                                                color: _subtleText),
                                            const SizedBox(width: 3),
                                            Text('( )', style: outFitRegular(fontSize: 11, fontWeight: FontWeight.bold)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            : Row(
                                children: [
                                  Expanded(
                                    child: _labelledField('PAY',
                                      SizedBox(
                                        height: _fieldHeight,
                                        child: _dropdown<String>(
                                          height: _fieldHeight,
                                          value: selectedPay,
                                          hint: 'ACCOUNT',
                                          items: payList,
                                          label: (item) => item,
                                          onChanged: (val) =>
                                              setState(() => selectedPay = val),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Focus(
                                          onKeyEvent: (node, event) {
                                            if (event is KeyDownEvent &&
                                                (event.logicalKey ==
                                                        LogicalKeyboardKey.enter ||
                                                    event.logicalKey ==
                                                        LogicalKeyboardKey.space)) {
                                              setState(() {
                                                isQuotationSelected =
                                                    !isQuotationSelected;
                                              });
                                              return KeyEventResult.handled;
                                            }
                                            return KeyEventResult.ignored;
                                          },
                                          child: SizedBox(
                                            width: 18,
                                            height: 18,
                                            child: Checkbox(
                                              value: isQuotationSelected,
                                              activeColor: DynamicColors.primaryClr,
                                              onChanged: (val) {
                                                setState(() {
                                                  isQuotationSelected =
                                                      val ?? false;
                                                });
                                              },
                                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Text('QUOTATION', style: outFitRegular(fontSize: 12, fontWeight: FontWeight.w700)),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Expanded(child: SizedBox()),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Container(
                                      height: _fieldHeight,
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: _border),
                                        borderRadius: BorderRadius.circular(4),
                                        color: _fieldFill,
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(
                                                  Icons.shopping_cart_outlined,
                                                  size: 14,
                                                  color: _subtleText),
                                              const SizedBox(width: 3),
                                              Text('( )',style: outFitRegular(fontSize: 11, fontWeight: FontWeight.bold)),
                                            ],
                                          ),
                                          Text('£', style: outFitRegular(fontSize: 12, fontWeight: FontWeight.bold)),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(
                                                  Icons.sticky_note_2_outlined,
                                                  size: 14,
                                                  color: _subtleText),
                                              const SizedBox(width: 3),
                                              Text('( )', style: outFitRegular(fontSize: 11, fontWeight: FontWeight.bold)),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // 2. ETA / Distance / Fare Container Bar
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: _fieldFill,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: _border),
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        bool isBarMobile = constraints.maxWidth < 550;

                        return isBarMobile
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Left metrics tightly grouped together
                                  Wrap(
                                    spacing: 12,
                                    runSpacing: 6,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.access_time,
                                              size: 14, color: _subtleText),
                                          const SizedBox(width: 3),
                                          Text('ETA: 0 M', style: outFitRegular(fontSize: 11, fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.place_outlined,
                                              size: 14, color: _subtleText),
                                          const SizedBox(width: 3),
                                          Text('DISTANCE: 0 M', style: outFitRegular(fontSize: 11, fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.payments_outlined,
                                              size: 14, color: _subtleText),
                                          const SizedBox(width: 3),
                                          Text('T/FARES: £ 0', style: outFitRegular(fontSize: 11, fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  // Fare section aligned to right on mobile
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text('FARE  ', style: outFitRegular(fontSize: 11, fontWeight: FontWeight.bold)),
                                      SizedBox(
                                        width: 80,
                                        height: 30,
                                        child: TextField(
                                            controller: fareController,
                                            style: _valStyle,
                                            decoration: _fieldDec()),
                                      ),
                                      const SizedBox(width: 6),
                                      Container(
                                        height: 30,
                                        width: 30,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(color: _border),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: Icon(Icons.calculate,
                                            size: 16,
                                            color: DynamicColors.primaryClr),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            : Row(
                                children: [
                                  // Left items tightly grouped together exactly like original
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(Icons.access_time,
                                          size: 14, color: _subtleText),
                                      const SizedBox(width: 3),
                                      Text('ETA: 0 M', style: outFitRegular(fontSize: 11, fontWeight: FontWeight.bold)),
                                      const SizedBox(width: 14),
                                      const Icon(Icons.place_outlined, size: 14, color: _subtleText),
                                      const SizedBox(width: 3),
                                      Text('DISTANCE: 0 M', style: outFitRegular(fontSize: 11, fontWeight: FontWeight.bold)),
                                      const SizedBox(width: 14),
                                      const Icon(Icons.payments_outlined,
                                          size: 14, color: _subtleText),
                                      const SizedBox(width: 3),
                                      Text('T/FARES: £ 0', style: outFitRegular(fontSize: 11, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  const Spacer(),
                                  // Right aligned FARE input section
                                  Text('FARE  ', style: outFitRegular(fontSize: 11, fontWeight: FontWeight.bold)),
                                  SizedBox(
                                    width: 80,
                                    height: 30,
                                    child: TextField(
                                        controller: fareController,
                                        style: _valStyle,
                                        decoration: _fieldDec()),
                                  ),
                                  const SizedBox(width: 6),
                                  Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(color: _border),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Icon(Icons.calculate,
                                        size: 16,
                                        color: DynamicColors.primaryClr),
                                  ),
                                ],
                              );
                      },
                    ),
                  ),
                  const SizedBox(height: 10),

                  // 3. Driver & Save Button Container
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: _border),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                            width: 35,
                            child: Text('DRV', style: outFitRegular(fontSize: _fsLabel, fontWeight: FontWeight.bold))),
                        const SizedBox(width: 6),
                        Expanded(
                          flex: 3,
                          child: _dropdown<String>(
                            height: 38,
                            value: selectedDriver,
                            hint: 'SELECT DRIVER',
                            items: driverList,
                            label: (item) => item,
                            onChanged: (val) =>
                                setState(() => selectedDriver = val),
                          ),
                        ),
                        const Spacer(flex: 3),
                        Expanded(
                          flex: 3,
                          child: SizedBox(
                            height: 38,
                            child: ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => const AccountDetailsAlert(),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: DynamicColors.primaryClr,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6)),
                              ),
                              child: Text('SAVE', style: mozillaTextSemiBoldText(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }

  // Helpers
  static final _valStyle = outFitRegular(
      fontSize: 12, fontWeight: FontWeight.w700, color: Colors.black);

  Widget _labelledField(String label, Widget child) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 38,
          child: Text(label, style: outFitRegular(fontSize: _fsLabel, fontWeight: FontWeight.bold, color: _subtleText)),
        ),
        const SizedBox(width: 4),
        Expanded(child: child),
      ],
    );
  }

  Widget _buildLocationRow(
    String label,
    TextEditingController ctrl,
    String noteHint,
    IconData actionIcon,
    String? zoneValue,
    List<String> zoneList,
    ValueChanged<String?> onZoneChanged,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 600;

        Widget buildSuffixIcons() {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1st Icon: Swap Horiz
              Focus(
                child: Builder(
                  builder: (context) {
                    final bool hasFocus = Focus.of(context).hasFocus;
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: hasFocus
                              ? DynamicColors.primaryClr
                              : Colors.transparent,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.swap_horiz,
                            size: 16, color: _subtleText),
                        onPressed: () {},
                        padding: EdgeInsets.zero,
                        constraints:
                            const BoxConstraints(minWidth: 24, minHeight: 24),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 6),
              // 2nd Icon: Action Icon (Arrow/Route)
              Focus(
                child: Builder(
                  builder: (context) {
                    final bool hasFocus = Focus.of(context).hasFocus;
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: hasFocus
                              ? DynamicColors.primaryClr
                              : Colors.transparent,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: IconButton(
                        icon: Icon(actionIcon, size: 15, color: _subtleText),
                        onPressed: () {},
                        padding: EdgeInsets.zero,
                        constraints:
                            const BoxConstraints(minWidth: 24, minHeight: 24),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 6),
            ],
          );
        }

        if (isMobile) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 44,
                    child: Text(label,
                        style: outFitRegular(
                            fontSize: _fsLabel, fontWeight: FontWeight.bold)),
                  ),
                  Expanded(
                    child: SizedBox(
                      height: 34,
                      child: TextField(
                        controller: ctrl,
                        style: _valStyle,
                        decoration: _fieldDec().copyWith(
                          suffixIcon: buildSuffixIcons(),
                          suffixIconConstraints:
                              const BoxConstraints(minWidth: 55),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: _dropdown<String>(
                      height: 34,
                      value: zoneValue,
                      hint: 'SELECT ZONE',
                      items: zoneList,
                      label: (item) => item,
                      onChanged: onZoneChanged,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SizedBox(
                      height: 34,
                      child: TextField(
                        style: outFitRegular(fontSize: 12),
                        decoration: _fieldDec().copyWith(
                          hintText: noteHint,
                          hintStyle:
                              outFitRegular(fontSize: 9, color: Colors.grey),
                          prefixIcon: const Icon(Icons.directions_car,
                              size: 14, color: _subtleText),
                          prefixIconConstraints:
                              const BoxConstraints(minWidth: 24),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        }

        return Row(
          children: [
            SizedBox(
              width: 44,
              child: Text(label,
                  style: outFitRegular(
                      fontSize: _fsLabel, fontWeight: FontWeight.bold)),
            ),
            Expanded(
              flex: 5,
              child: SizedBox(
                height: 34,
                child: TextField(
                  controller: ctrl,
                  style: _valStyle,
                  decoration: _fieldDec().copyWith(
                    suffixIcon: buildSuffixIcons(),
                    suffixIconConstraints: const BoxConstraints(minWidth: 55),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 162,
              child: _dropdown<String>(
                height: 34,
                value: zoneValue,
                hint: 'SELECT ZONE',
                items: zoneList,
                label: (item) => item,
                onChanged: onZoneChanged,
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 162,
              height: 34,
              child: TextField(
                style: outFitRegular(fontSize: 12),
                decoration: _fieldDec().copyWith(
                  hintText: noteHint,
                  hintStyle: outFitRegular(fontSize: 9, color: Colors.grey),
                  prefixIcon: const Icon(Icons.directions_car,
                      size: 14, color: _subtleText),
                  prefixIconConstraints: const BoxConstraints(minWidth: 24),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  InputDecoration _fieldDec({IconData? suffix}) {
    return InputDecoration(
      isDense: true,
      filled: true,
      fillColor: _fieldFill,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: _border)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(color: _border)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: DynamicColors.primaryClr, width: 1.5)),
      suffixIcon:
          suffix != null ? Icon(suffix, size: 14, color: _subtleText) : null,
      suffixIconConstraints: const BoxConstraints(minWidth: 24),
    );
  }

  Widget _dateBox() {
    final now = DateTime.now();
    final currentDate = '${now.day.toString().padLeft(2, '0')}/'
        '${now.month.toString().padLeft(2, '0')}/'
        '${now.year}';

    return Container(
      height: 32,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: _fieldFill,
        border: Border.all(color: _border),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        currentDate,
        style: _valStyle,
      ),
    );
  }

  Widget _timePickerBox() {
    return SizedBox(
      height: 32,
      child: TimePickerField(
        controller: TextEditingController(),
        showPrefixIcon: false,
        textStyle: _valStyle,
        accent: DynamicColors.primaryClr,
        borderColor: _border,
        decoration: _fieldDec().copyWith(
          suffixIcon: const Icon(
            Icons.access_time,
            size: 14,
            color: _subtleText,
          ),
          suffixIconConstraints: const BoxConstraints(
            minWidth: 28,
            minHeight: 0,
          ),
        ),
      ),
    );
  }

  Widget _dropdown<T>({
    required T? value,
    required String hint,
    required List<T>? items,
    required String Function(T) label,
    required ValueChanged<T?> onChanged,
    double? width,
    double height = 48,
  }) {
    return CustomDropdownField<T>(
      height: height,
      width: width,
      label: hint,
      items: items ?? [],
      value: value,
      itemLabel: label,
      onChanged: onChanged,
    );
  }
}
