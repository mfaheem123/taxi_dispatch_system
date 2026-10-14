import 'package:dashboard_new1/component/action_icon_button.dart';
import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../alert/multi_reservation_alert.dart';
import '../../component/responsive_datatable_widget.dart';

class MultiReservationScreen extends StatefulWidget {
  const MultiReservationScreen({super.key});

  @override
  State<MultiReservationScreen> createState() => _MultiReservationScreenState();
}

class _MultiReservationScreenState extends State<MultiReservationScreen> {

  static const Color _border = Color(0xFFE1E7F0);
  static const Color _fieldFill = Color(0xFFF2F5F9);
  static const Color _subtleText = Color(0xFF475569);

  static const double _fsLabel = 11.0;

  int selectedRowIndex = 0;

  // Controllers
  final TextEditingController pickController = TextEditingController();
  final TextEditingController dropController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobController = TextEditingController();
  final TextEditingController telController = TextEditingController();
  final TextEditingController fareController = TextEditingController();

  final List<Map<String, String>> reservations = [
    {'datetime': 'MON 05-10-26 09:00', 'ref': 'DCB75891', 'jt': 'R/N'},
    {'datetime': 'WED 07-10-26 09:00', 'ref': 'DCB75892', 'jt': 'R/N'},
    {'datetime': 'FRI 09-10-26 09:00', 'ref': 'DCB75881', 'jt': 'R/N'},
    {'datetime': 'MON 12-10-26 09:00', 'ref': 'DCB75893', 'jt': 'R/N'},
    {'datetime': 'WED 14-10-26 09:00', 'ref': 'DCB75894', 'jt': 'R/N'},
    {'datetime': 'FRI 16-10-26 09:00', 'ref': 'DCB75895', 'jt': 'R/N'},
    {'datetime': 'MON 19-10-26 09:00', 'ref': 'DCB75896', 'jt': 'R/N'},
    {'datetime': 'WED 21-10-26 09:00', 'ref': 'DCB75897', 'jt': 'R/N'},
    {'datetime': 'FRI 23-10-26 09:00', 'ref': 'DCB75898', 'jt': 'R/N'},
    {'datetime': 'MON 26-10-26 09:00', 'ref': 'DCB75899', 'jt': 'R/N'},
    {'datetime': 'WED 28-10-26 09:00', 'ref': 'DCB75900', 'jt': 'R/N'},
    {'datetime': 'FRI 30-10-26 09:00', 'ref': 'DCB75901', 'jt': 'R/N'},
    {'datetime': 'MON 05-10-26 18:10', 'ref': 'DCB75891', 'jt': 'R/N'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(padding: EdgeInsetsGeometry.all(16.0),
      child: Column(
        children: [
          // Main Body split across the full screen width
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ────────── LEFT: Responsive DataTable Section ──────────
                SizedBox(
                  width: 390,
                    child: SingleChildScrollView(
                      child: ResponsiveDataTableWidget(
                        totalWidth: 390,
                        headerBackgroundColor: Colors.grey.shade200,
                        columnConfigs: [
                          TableColumnConfig(
                            title: "RADIO",
                            sizeType: ColumnSizeType.fixed,
                            fixedWidth: 32.0,
                            removeSearching: true,
                            customHeader: Center(
                              child: Radio(
                              value: false,
                              onChanged: (v) {},
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          )),
                          TableColumnConfig(
                            title: "DATETIME",
                            sizeType: ColumnSizeType.large,
                          ),
                          TableColumnConfig(
                            title: "REF #",
                            sizeType: ColumnSizeType.medium,
                          ),
                          TableColumnConfig(
                            title: "J/T",
                            sizeType: ColumnSizeType.small,
                          ),
                          TableColumnConfig(
                            title: "ACTION",
                            sizeType: ColumnSizeType.fixed,
                            fixedWidth: 36.0,
                            removeSearching: true,
                          ),
                        ],
                        items: reservations,
                        rowBuilder: (item, widths) {
                          final index = reservations.indexOf(item);
                          final isSelected = selectedRowIndex == index;

                          return [
                            // Radio Column
                            Center(
                          child: SizedBox(
                              width: widths["RADIO"],
                              child: Radio<int>(
                                value: index,
                                groupValue: selectedRowIndex,
                                activeColor: DynamicColors.primaryClr,
                                onChanged: (val) => setState(() => selectedRowIndex = val!),
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                visualDensity: VisualDensity.compact,
                              ),
                            )),
                            // Datetime
                            Center(child: Text(item['datetime']!, style: outFitRegular(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)))),// Ref #
                            Center(child: Text(item['ref']!, style: outFitRegular(fontSize: 12, color: Color(0xFF1E293B)))),
                            Center(child: Text(item['jt']!, style: outFitRegular(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)))),
                            // Action Icon

                            Center(
                                child: SizedBox(
                              width: widths["ACTION"],
                              child: ActionIconButton(
                                icon: Icons.visibility_outlined, size: 16, color: Color(0xFF16A34A),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => MultiReservationAlert(item: item),
                                  );
                                },
                              ),
                            )),
                          ];
                        },
                      ),
                    ),
                  ),

                // ────────── RIGHT: Compact Form Section with Separate Containers ──────────
                Expanded(
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // User Banner
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
                              // PICK Location
                              _buildLocationRow('PICK', pickController, 'PICKUP NOTES', LucideIcons.arrowDownUp),
                              const SizedBox(height: 8),

                              // DROP Location
                              _buildLocationRow('DROP', dropController, 'DROPOFF NOTES', LucideIcons.route),
                              const SizedBox(height: 10),

                              // Name, Email, Mob, Tel
                              Row(
                                children: [
                                  Expanded(flex: 3, child: _labelledField('NAME', TextField(controller: nameController, style: _valStyle, decoration: _fieldDec(suffix: Icons.search)))),
                                  const SizedBox(width: 8),
                                  Expanded(flex: 3, child: _labelledField('EMAIL', TextField(controller: emailController, style: _valStyle, decoration: _fieldDec()))),
                                  const SizedBox(width: 8),
                                  Expanded(flex: 3, child: _labelledField('MOB', TextField(controller: mobController, style: _valStyle, decoration: _fieldDec(suffix: Icons.search)))),
                                  const SizedBox(width: 8),
                                  Expanded(flex: 3, child: _labelledField('TEL', TextField(controller: telController, style: _valStyle, decoration: _fieldDec(suffix: Icons.search)))),
                                ],
                              ),
                              const SizedBox(height: 10),

                              // Date & Time
                              Row(
                                children: [
                                  Expanded(flex: 3, child: _labelledField('DATE', _timeBox('10/30/2026', Icons.calendar_today))),
                                  const SizedBox(width: 8),
                                  Expanded(flex: 3, child: _labelledField('TIME', _timeBox('--:-- --', Icons.access_time))),
                                  const Spacer(flex: 6),
                                ],
                              ),
                              const SizedBox(height: 10),

                              // Lead, Jour, Veh
                              Row(
                                children: [
                                  Expanded(flex: 3, child: _labelledField('LEAD', _timeBox('--:-- --', Icons.access_time))),
                                  const SizedBox(width: 8),
                                  Expanded(flex: 3, child: _labelledField('JOUR', _dropdownBox('R/N'))),
                                  const SizedBox(width: 8),
                                  Expanded(flex: 3, child: _labelledField('VEH', _dropdownBox('SELECT VEHICLE'))),
                                  const Spacer(flex: 3),
                                ],
                              ),
                              const SizedBox(height: 10),

                              // Acc, Pass, Lugg, Slgg
                              Row(
                                children: [
                                  Expanded(flex: 3, child: _labelledField('ACC', _dropdownBox('SELECT ACCOUNT'))),
                                  const SizedBox(width: 8),
                                  Expanded(flex: 3, child: _labelledField('PASS', TextField(style: _valStyle, decoration: _fieldDec()))),
                                  const SizedBox(width: 8),
                                  Expanded(flex: 3, child: _labelledField('LUGG', TextField(style: _valStyle, decoration: _fieldDec()))),
                                  const SizedBox(width: 8),
                                  Expanded(flex: 3, child: _labelledField('SLGG', TextField(style: _valStyle, decoration: _fieldDec()))),
                                ],
                              ),
                              const SizedBox(height: 10),

                              // Pay, Quotation, Icons
                              Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: _labelledField('PAY', _dropdownBox('ACCOUNT')),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    flex: 3,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: Radio(
                                            value: false,
                                            onChanged: (_) {},
                                            activeColor: DynamicColors.primaryClr,
                                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Text('QUOTATION', style: outFitRegular(fontSize: 12, fontWeight: FontWeight.w700)),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    flex: 3,
                                    child: Container(
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
                                              Icon(Icons.shopping_cart_outlined, size: 14, color: _subtleText),
                                              SizedBox(width: 3),
                                              Text('( )', style: outFitRegular(fontSize: 11, fontWeight: FontWeight.bold)),
                                            ],
                                          ),
                                          Text('£', style: outFitRegular(fontSize: 12, fontWeight: FontWeight.bold)),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.sticky_note_2_outlined, size: 14, color: _subtleText),
                                              SizedBox(width: 3),
                                              Text('( )', style: outFitRegular(fontSize: 11, fontWeight: FontWeight.bold)),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),

                        // 2. ETA / Distance / Fare Container Bar
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(color: _fieldFill, borderRadius: BorderRadius.circular(6), border: Border.all(color: _border)),
                          child: Row(
                            children: [
                              const Icon(Icons.access_time, size: 14, color: _subtleText),  Text(' ETA: 0 M  ', style: outFitRegular(fontSize: 12, fontWeight: FontWeight.bold)),
                              const Icon(Icons.place_outlined, size: 14, color: _subtleText),  Text(' DISTANCE: 0 M  ', style: outFitRegular(fontSize: 12, fontWeight: FontWeight.bold)),
                              const Icon(Icons.payments_outlined, size: 14, color: _subtleText), Text(' T/FARES: £ 0', style: outFitRegular(fontSize: 12, fontWeight: FontWeight.bold)),
                              const Spacer(),
                              Text('FARE  ', style: outFitRegular(fontSize: 11, fontWeight: FontWeight.bold)),
                              SizedBox(
                                width: 80,
                                height: 30,
                                child: TextField(controller: fareController, style: _valStyle, decoration: _fieldDec()),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(color: Colors.white, border: Border.all(color: _border), borderRadius: BorderRadius.circular(4)),
                                child: Icon(Icons.calculate, size: 16, color: DynamicColors.primaryClr),
                              ),
                            ],
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
                               SizedBox(width: 35, child: Text('DRV', style: outFitRegular(fontSize: _fsLabel, fontWeight: FontWeight.bold))),
                              const SizedBox(width: 6),
                              Expanded(flex: 3, child: _dropdownBox('SELECT DRIVER')),
                              // const SizedBox(width: 16),
                              Spacer(flex:3),
                              Expanded(
                                flex: 3,
                                child: SizedBox(
                                  height: 38,
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: DynamicColors.primaryClr,
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
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
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }

  // Helpers
  static final _valStyle = outFitRegular(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.black);

  Widget _tableHeaderCell(String text) {
    return Row(
      children: [
        Container(width: 1, height: 40, color: _border),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(text, style: outFitRegular(fontSize: 12, fontWeight: FontWeight.w700, color: _subtleText)),
          ),
        ),
      ],
    );
  }

  Widget _labelledField(String label, Widget child) {
    return Row(
      children: [
        SizedBox(width: 40, child: Text(label, style: outFitRegular(fontSize: _fsLabel, fontWeight: FontWeight.bold, color: _subtleText))),
        const SizedBox(width: 4),
        Expanded(child: child),
      ],
    );
  }

  Widget _buildLocationRow(String label, TextEditingController ctrl, String noteHint, IconData actionIcon) {
    return Row(
      children: [
        SizedBox(
          width: 44,
          child: Row(
            children: [
              Text(label, style: outFitRegular(fontSize: _fsLabel, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        Expanded(
          flex: 5,
          child: SizedBox(
            height: 34,
            child: TextField(
              controller: ctrl,
              style: _valStyle,
              decoration: _fieldDec().copyWith(
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(icon: const Icon(Icons.swap_horiz, size: 16, color: _subtleText), onPressed: () {}, padding: EdgeInsets.zero, constraints: const BoxConstraints()),
                    const SizedBox(width: 6),
                    IconButton(icon: Icon(actionIcon, size: 15, color: _subtleText), onPressed: () {}, padding: EdgeInsets.zero, constraints: const BoxConstraints()),
                    const SizedBox(width: 6),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(width: 162, child: _dropdownBox('SELECT ZONE')),
        const SizedBox(width: 8),
        SizedBox(
          width: 162,
          height: 34,
          child: TextField(
            style: outFitRegular(fontSize: 12),
            decoration: _fieldDec().copyWith(
              hintText: noteHint,
              hintStyle: outFitRegular(fontSize: 9, color: Colors.grey),
              prefixIcon: const Icon(Icons.directions_car, size: 14, color: _subtleText),
              prefixIconConstraints: const BoxConstraints(minWidth: 24),
            ),
          ),
        ),
      ],
    );
  }

  InputDecoration _fieldDec({IconData? suffix}) {
    return InputDecoration(
      isDense: true,
      filled: true,
      fillColor: _fieldFill,
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(color: _border)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: const BorderSide(color: _border)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: DynamicColors.primaryClr, width: 1.5)),
      suffixIcon: suffix != null ? Icon(suffix, size: 14, color: _subtleText) : null,
      suffixIconConstraints: const BoxConstraints(minWidth: 24),
    );
  }

  InputDecoration _filterDecoration(String hint, {IconData? prefix}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: outFitRegular(fontSize: 12, color: _subtleText),
      isDense: true,
      filled: true,
      fillColor: _fieldFill,
      prefixIcon: prefix != null ? Icon(prefix, size: 12, color: _subtleText) : null,
      prefixIconConstraints: const BoxConstraints(minWidth: 22),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(4), borderSide: const BorderSide(color: _border)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
    );
  }

  Widget _timeBox(String text, IconData icon) {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(color: _fieldFill, border: Border.all(color: _border), borderRadius: BorderRadius.circular(5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(text, style: _valStyle), Icon(icon, size: 14, color: _subtleText)],
      ),
    );
  }

  Widget _dropdownBox(String hint) {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(color: _fieldFill, border: Border.all(color: _border), borderRadius: BorderRadius.circular(5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(hint, maxLines: 1, overflow: TextOverflow.ellipsis, style: outFitRegular(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black87))),
          const Icon(Icons.arrow_drop_down, size: 16, color: _subtleText),
        ],
      ),
    );
  }
}