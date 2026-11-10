import 'package:bot_toast/bot_toast.dart';
import 'package:dashboard_new1/component/action_icon_button.dart';
import 'package:dashboard_new1/component/color.dart';
import 'package:dashboard_new1/component/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:timepickerfield/timepickerfield.dart';
import 'package:flutter_web_date_picker/flutter_web_date_picker.dart' show GlowFocus;
import '../../alert/child_seats_alert.dart';
import '../../alert/extra_info_alert.dart';
import '../../alert/setting_dialog.dart';
import '../../alert/multi_booking_alert.dart';
import '../../component/dropdown_button.dart';
import '../../component/responsive_datatable_widget.dart';
import '../../component/text_field.dart' show UpperCaseTextFormatter;
import '../accounts/model/list_escort_model.dart' show Escorts;
import '../auth/dashboard_form_widget.dart'
    show AddressModelAutocomplete, CustomerModelAutocomplete;
import '../dashboard_view/Controller/dashboard_controller.dart';
import '../dashboard_view/models/account_darshboard_model.dart';
import '../dashboard_view/models/dashboard_model.dart';
import 'controller.dart';
import '../dashboard_view/widgets/via_location.dart';
import '../locations_view/Model/location_types_zoneModel.dart' show ZoneObject;
import '../locations_view/controller/locations_controller.dart';

class MultiReservationScreen extends StatefulWidget {
  const MultiReservationScreen({super.key, this.multiBookingId});

  /// The multi booking whose reservations fill the left table — the `id` of
  /// the row picked on the MULTI BOOKINGS list.
  final String? multiBookingId;

  @override
  State<MultiReservationScreen> createState() => _MultiReservationScreenState();
}

class _MultiReservationScreenState extends State<MultiReservationScreen> {
  TimeOfDay? selectedTime;

  bool isAllSelected = false;
  Set<int> selectedRowIndices = {};

  static const Color _border = Color(0xFFE1E7F0);
  static const Color _fieldFill = Color(0xFFF2F5F9);
  static const Color _subtleText = Color(0xFF475569);

  static const double _fsLabel = 11.0;
  static const double _fieldHeight = 34.0;

  int selectedRowIndex = 0;

  // ---------------------------------------------------------------------------
  // Same controllers / variables the dashboard booking form
  // (lib/view/auth/dashboard_form_widget.dart) reads and writes.
  // ---------------------------------------------------------------------------
  final DashboardController controller = Get.isRegistered<DashboardController>()
      ? Get.find<DashboardController>()
      : Get.put(DashboardController());
  final LocationController _locationController =
      Get.isRegistered<LocationController>()
          ? Get.find<LocationController>()
          : Get.put(LocationController());

  /// Zones list — same source as the PICKUP / DROP zone dropdowns on the
  /// dashboard form.
  List<ZoneObject> get _zoneList =>
      _locationController.updateLocationValue.value == true ||
              _locationController.locationtypezoneModel == null
          ? []
          : _locationController.locationtypezoneModel!.zonesList ?? [];

  /// PICK / DROP address fields — the ✕ puts the caret back here after
  /// clearing, the same as the dashboard form.
  final FocusNode _pickupFocusNode = FocusNode();
  final FocusNode _dropFocusNode = FocusNode();

  @override
  void dispose() {
    _pickupFocusNode.dispose();
    _dropFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (controller.dashboardAllData == null) {
      controller.dashboardData();
    }
    if (_locationController.locationtypezoneModel == null) {
      _locationController.getLocationTypeZone();
    }
    if (controller.escortList.isEmpty) {
      controller.fetchEscortList();
    }
    _bookingController.getMultiReservations(widget.multiBookingId);
  }

  /// Owns the reservations table's data (API call and row mapping).
  final BookingController _bookingController =
      Get.isRegistered<BookingController>()
          ? Get.find<BookingController>()
          : Get.put(BookingController());

  /// Rows of the left table, loaded by
  /// [BookingController.getMultiReservations].
  List<Map<String, String>> get reservations =>
      _bookingController.multiReservations;

  /// The O/W entry of the journey types (falls back to the first one, which
  /// is O/W in the dashboard data).
  JourneyTypeObject? get _oneWayJourney {
    final types = controller.dashboardAllData?.journeyTypes ?? [];
    if (types.isEmpty) return null;
    return types.firstWhere(
      (t) => (t.journeyType ?? '').trim().toUpperCase() == 'O/W',
      orElse: () => types.first,
    );
  }

  /// JOUR is fixed to O/W on this screen: it looks like the other dropdowns
  /// but can't be opened, tabbed to or changed. The controller is kept on
  /// O/W too, so a booking loaded from the table (which may be R/N or W/R)
  /// can't switch the journey or its fares.
  Widget _lockedJourneyField({double height = 48}) {
    final oneWay = _oneWayJourney;
    if (oneWay != null) {
      controller.selectJourneyTypeValue = oneWay;
      controller.jourValue = 'O/W';
    }
    return IgnorePointer(
      child: ExcludeFocus(
        child: _dropdown<JourneyTypeObject>(
          height: height,
          value: oneWay,
          hint: 'O/W',
          items: oneWay == null ? [] : [oneWay],
          label: (item) => item.journeyType ?? '',
          onChanged: (_) {},
        ),
      ),
    );
  }

  /// SAVE: applies the form's pickup / dropoff (with lat/lng), date and time
  /// to every booking ticked in the left table. Clears the ticks on success.
  Future<void> _saveSelectedReservations() async {
    if (_bookingController.multiReservationsSaving.value) return;
    final rows = reservations;
    final ids = (selectedRowIndices.toList()..sort())
        .where((i) => i < rows.length)
        .map((i) => rows[i]['id'] ?? '')
        .where((id) => id.isNotEmpty)
        .toList();
    final ok = await _bookingController.updateMultiReservations(
      ids: ids,
      multiBookingId: widget.multiBookingId,
    );
    if (ok && mounted) {
      setState(() {
        selectedRowIndices.clear();
        isAllSelected = false;
      });
    }
  }

  void _onAccountChanged(DashboardAccountObject? v) {
    setState(() {
      controller.selectAccountValue = v;
      controller.selectDepartmentData = null;
      if (controller.escortList.isEmpty) {
        controller.fetchEscortList();
      }
    });
  }

  void _onDepartmentChanged(DepartmentObject? v) {
    setState(() {
      controller.selectDepartmentData = v;
      controller.update();
    });
  }

  void _onVehicleChanged(DashboardVehicleTypeObject? v) {
    setState(() {
      controller.selectVehicleValue = v;
      if (v != null && v.passengers != null) {
        controller.passController.text = v.passengers.toString();
      }
      controller.validatePassengerLimit(controller.passController.text);
      controller.getFaresCalculation();
    });
  }

  /// Typing in PICK / DROP — same search the dashboard form fires.
  void _onAddressTyped(String fieldName, String value) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.dropDownShow.value = value.isNotEmpty;
      controller.onChangeHandler(fieldName: fieldName, searchingText: value);
    });
    if (value.isEmpty) _clearLocation(fieldName);
  }

  /// Emptying PICK / DROP — same reset the dashboard form's clear runs.
  void _clearLocation(String fieldName) {
    final isPickup = fieldName == 'PICKUP LOCATION';
    final polyIndex = controller.polyLineMarkerInfo
        .indexWhere((e) => e.markerType == fieldName);
    if (polyIndex >= 0) controller.polyLineMarkerInfo.removeAt(polyIndex);
    final markerIndex = controller.markers
        .indexWhere((e) => e.type == (isPickup ? 'pickup' : 'dropOff'));
    if (markerIndex >= 0) controller.markers.removeAt(markerIndex);
    (isPickup ? controller.pickupController : controller.dropOffController)
        .clear();
    controller.dropDownShow.value = false;
    controller.suggestions.clear();
    controller.clearViaIfNoPickupAndDrop();
    controller.totalDistance.value = '0.00';
    controller.totalTimeDuration.value = '0 min';
    controller.fixedFare.value = '0';
    controller.returnFareValue = '0';
    controller.tempStoreViaMils = '0';
    controller.slugController.clear();
    controller.slugControllerReturn.clear();
    controller.tempStoreMils = null;
    controller.fetchRouteFromOSRM();
    controller.update();
  }

  /// Address search field for PICK / DROP — same suggestion panel as the
  /// dashboard form, wearing this screen's own field decoration.
  Widget _addressField(TextEditingController ctrl, String fieldName,
      InputDecoration decoration) {
    return AddressModelAutocomplete(
      controller: ctrl,
      items: controller.allAddressesData,
      textStyle: _valStyle,
      decoration: decoration,
      focusNode:
          fieldName == 'PICKUP LOCATION' ? _pickupFocusNode : _dropFocusNode,
      onChanged: (value) => _onAddressTyped(fieldName, value),
      onPickIndex: (index) => controller.tapSelect(index),
    );
  }

  /// Small loader in front of PICK / DROP while that field's address search
  /// is running — same as the dashboard form. The slot is 0 wide the rest of
  /// the time, so the field only gives up the space while searching.
  Widget _searchLoader(String searchFieldName) {
    return Obx(() {
      final on = controller.addressSearchField.value == searchFieldName;
      return ClipRect(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          width: on ? 22 : 0,
          height: 14,
          child: OverflowBox(
            alignment: Alignment.centerLeft,
            minWidth: 0,
            minHeight: 0,
            maxWidth: 22,
            child: on
                ? SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      strokeAlign: CircularProgressIndicator.strokeAlignInside,
                      color: DynamicColors.primaryClr,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ),
      );
    });
  }

  /// DROP's via icon — same check and dialog as the dashboard form. No
  /// formController: this screen runs on the untagged dashboard controller,
  /// which is what ViaLocation falls back to.
  void _openViaLocations() {
    if (controller.pickupController.text.isEmpty) {
      BotToast.showText(text: 'Please write pickup and dropoff location');
      return;
    }
    showDialog(
      context: context,
      builder: (_) => ViaLocation(),
    );
  }

  /// MOB field — same customer phone search as the dashboard form.
  Widget _mobileField() {
    return CustomerModelAutocomplete(
      controller: controller.mobileController,
      items: controller.customerPhoneNumber?.customerInfo ?? const [],
      textStyle: _valStyle,
      decoration: _fieldDec(suffix: Icons.search),
      onChanged: (q) {
        if (q.trim().isEmpty) return;
        controller.onPhoneNoChangeHandler(
            fieldName: 'Phone Number', searchingText: q);
      },
      onSelected: (c) => setState(() {
        controller.mobileController.text = c.mobile ?? '';
        controller.nameController.text = c.name ?? '';
        controller.emailController.text = c.email ?? '';
        controller.telController.text = c.telephone ?? '';
      }),
    );
  }

  List<DepartmentObject> get _departmentList =>
      controller.selectAccountValue?.departments ?? [];


  @override
  Widget build(BuildContext context) {
    return FocusTraversalGroup(
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
    );
  }

  // ────────── Left Table Section Widget ──────────
  Widget _buildLeftTableSection() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(right: BorderSide(color: _border, width: 1)),
      ),
      // Rebuilds when the controller's rows or loading flag change.
      child: Obx(() => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _reservationsTable(reservations.toList()),
          if (_bookingController.multiReservationsLoad.value)
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                    strokeWidth: 2.4, color: DynamicColors.primaryClr),
              ),
            )
          else if (reservations.isEmpty)
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text('NO RESERVATIONS FOUND',
                  style: outFitRegular(fontSize: 12, color: Colors.grey)),
            ),
        ],
      )),
    );
  }

  Widget _reservationsTable(List<Map<String, String>> rows) {
    return ResponsiveDataTableWidget(
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
        items: rows,
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
                          // Same as ticking with the mouse: load this
                          // booking (addresses, lat/lng, vias) into the form.
                          controller.dashBoardDataBinding(id: item['id']);
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
      );
  }

  // ────────── Right Form Section Widget ──────────
  Widget _buildRightFormSection() {
    return GetBuilder<DashboardController>(
      builder: (_) => FocusTraversalGroup(
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
                        _buildLocationRow('PICK', 'PICKUP LOCATION', controller.pickupController, controller.pickUpNoteController,
                            'PICKUP NOTES', LucideIcons.arrowDownUp,
                            controller.dashboardZoneValue, _zoneList, (val) => setState(() {
                              controller.dashboardZoneValue = val;
                              controller.getFaresCalculation();
                            })),
                        const SizedBox(height: 8),
                        _buildLocationRow('DROP', 'DROP LOCATION', controller.dropOffController, controller.dropUpNoteController,
                            'DROPOFF NOTES', LucideIcons.route,
                            controller.dashboardDZoneValue, _zoneList, (val) => setState(() {
                              controller.dashboardDZoneValue = val;
                              controller.getFaresCalculation();
                            })),
                        const SizedBox(height: 10),

                        // Name, Email, Mob, Tel (Responsive)
                        isFormMobile
                            ? Column(
                                children: [
                                  _labelledField('NAME',
                                      _tab(7, TextField(textCapitalization: TextCapitalization.characters, inputFormatters: [UpperCaseTextFormatter()], controller: controller.nameController, style: _valStyle, decoration: _fieldDec(suffix: Icons.search)))),
                                  const SizedBox(height: 8),
                                  _labelledField('EMAIL',
                                      _tab(8, TextField(textCapitalization: TextCapitalization.characters, inputFormatters: [UpperCaseTextFormatter()], controller: controller.emailController, style: _valStyle, decoration: _fieldDec()))),
                                  const SizedBox(height: 8),
                                  _labelledField('MOB',
                                      _tab(9, _mobileField())),
                                  const SizedBox(height: 8),
                                  _labelledField('TEL',
                                      _tab(10, TextField(textCapitalization: TextCapitalization.characters, inputFormatters: [UpperCaseTextFormatter()], controller: controller.telController, style: _valStyle, decoration: _fieldDec(suffix: Icons.search)))),
                                ],
                              )
                            : Row(
                                children: [
                                  Expanded(
                                      flex: 3,
                                      child: _labelledField('NAME',
                                          _tab(7, TextField(textCapitalization: TextCapitalization.characters, inputFormatters: [UpperCaseTextFormatter()], controller: controller.nameController, style: _valStyle, decoration: _fieldDec(suffix: Icons.search))))),
                                  const SizedBox(width: 8),
                                  Expanded(
                                      flex: 3,
                                      child: _labelledField('EMAIL',
                                          _tab(8, TextField(textCapitalization: TextCapitalization.characters, inputFormatters: [UpperCaseTextFormatter()], controller: controller.emailController, style: _valStyle, decoration: _fieldDec())))),
                                  const SizedBox(width: 8),
                                  Expanded(
                                      flex: 3,
                                      child: _labelledField('MOB',
                                          _tab(9, _mobileField()))),
                                  const SizedBox(width: 8),
                                  Expanded(
                                      flex: 3,
                                      child: _labelledField('TEL',
                                          _tab(10, TextField(textCapitalization: TextCapitalization.characters, inputFormatters: [UpperCaseTextFormatter()], controller: controller.telController, style: _valStyle, decoration: _fieldDec(suffix: Icons.search))))),
                                ],
                              ),
                        const SizedBox(height: 10),

                        // Date & Time (Responsive)
                        isFormMobile
                            ? Column(
                                children: [
                                  _labelledField('DATE', _dateBox()),
                                  const SizedBox(height: 8),
                                  _labelledField('TIME', _tab(11, _timePickerBox(controller.pickUpTimeController))),
                                ],
                              )
                            : Row(
                                children: [
                                  Expanded(
                                      child: _labelledField('DATE', SizedBox(height: _fieldHeight, child: _dateBox()))),
                                  const SizedBox(width: 8),
                                  Expanded(
                                      child: _labelledField('TIME', _tab(11, SizedBox(height: _fieldHeight, child: _timePickerBox(controller.pickUpTimeController))))),
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
                                  _labelledField('LEAD', _tab(12, _timePickerBox(controller.minController))),
                                  const SizedBox(height: 8),
                                  _labelledField('JOUR',
                                    _lockedJourneyField(),
                                  ),
                                  const SizedBox(height: 8),
                                  _labelledField('VEH',
                                    _tab(14, _dropdown<DashboardVehicleTypeObject>(
                                      value: controller.selectVehicleValue,
                                      hint: 'SELECT VEHICLE',
                                      items: controller.dashboardAllData?.vehicleTypes ?? [],
                                      label: (item) => item.name ?? '',
                                      onChanged: _onVehicleChanged,
                                    )),
                                  ),
                                ],
                              )
                            : Row(
                                children: [
                                  Expanded(
                                      child: _labelledField('LEAD', _tab(12, SizedBox(height: _fieldHeight, child: _timePickerBox(controller.minController))))),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: _labelledField('JOUR',
                                      SizedBox(height: _fieldHeight,
                                        child: _lockedJourneyField(height: _fieldHeight),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: _labelledField('VEH',
                                      _tab(14, SizedBox(
                                        height: _fieldHeight,
                                        child: _dropdown<DashboardVehicleTypeObject>(
                                          height: _fieldHeight,
                                          value: controller.selectVehicleValue,
                                          hint: 'SELECT VEHICLE',
                                          items: controller.dashboardAllData?.vehicleTypes ?? [],
                                          label: (item) => item.name ?? '',
                                          onChanged: _onVehicleChanged,
                                        ),
                                      )),
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
                                    _tab(15, _dropdown<DashboardAccountObject>(
                                      value: controller.selectAccountValue,
                                      hint: 'SELECT ACCOUNT',
                                      items: controller.dashboardAccountData?.accounts ?? [],
                                      label: (item) => item.name ?? '',
                                      onChanged: _onAccountChanged,
                                    )),
                                  ),
                                  const SizedBox(height: 8),
                                  _labelledField('PASS', _tab(16, TextField(textCapitalization: TextCapitalization.characters, inputFormatters: [UpperCaseTextFormatter()], controller: controller.passController, style: _valStyle, decoration: _fieldDec()))),
                                  const SizedBox(height: 8),
                                  _labelledField('LUGG', _tab(17, TextField(textCapitalization: TextCapitalization.characters, inputFormatters: [UpperCaseTextFormatter()], controller: controller.luggController, style: _valStyle, decoration: _fieldDec()))),
                                  const SizedBox(height: 8),
                                  _labelledField('SLGG', _tab(18, TextField(textCapitalization: TextCapitalization.characters, inputFormatters: [UpperCaseTextFormatter()], controller: controller.sluggController, style: _valStyle, decoration: _fieldDec()))),
                                ],
                              )
                            : Row(
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: _labelledField('ACC',
                                      _tab(15, _dropdown<DashboardAccountObject>(
                                        height: _fieldHeight,
                                        value: controller.selectAccountValue,
                                        hint: 'SELECT ACCOUNT',
                                        items: controller.dashboardAccountData?.accounts ?? [],
                                        label: (item) => item.name ?? '',
                                        onChanged: _onAccountChanged,
                                      )),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                      flex: 3,
                                      child: _labelledField('PASS', _tab(16, TextField(textCapitalization: TextCapitalization.characters, inputFormatters: [UpperCaseTextFormatter()], controller: controller.passController, style: _valStyle, decoration: _fieldDec())))),
                                  const SizedBox(width: 8),
                                  Expanded(
                                      flex: 3,
                                      child: _labelledField('LUGG', _tab(17, TextField(textCapitalization: TextCapitalization.characters, inputFormatters: [UpperCaseTextFormatter()], controller: controller.luggController, style: _valStyle, decoration: _fieldDec())))),
                                  const SizedBox(width: 8),
                                  Expanded(
                                      flex: 3,
                                      child: _labelledField('SLGG', _tab(18, TextField(textCapitalization: TextCapitalization.characters, inputFormatters: [UpperCaseTextFormatter()], controller: controller.sluggController, style: _valStyle, decoration: _fieldDec())))),
                                ],
                              ),
                        const SizedBox(height: 10),
                        isFormMobile
                            ? Column(
                                children: [
                                  _labelledField('DEPT',
                                    _tab(19, _dropdown<DepartmentObject>(
                                      value: controller.selectDepartmentData,
                                      hint: 'SELECT DEPT',
                                      items: _departmentList,
                                      label: (item) => item.name ?? '',
                                      onChanged: _onDepartmentChanged,
                                    )),
                                  ),
                                  const SizedBox(height: 8),
                                  _labelledField('ESC',
                                    _tab(20, _dropdown<Escorts>(
                                      value: controller.selectEscortValue,
                                      hint: 'SELECT ESC',
                                      items: controller.escortList,
                                      label: (item) => (item.name ?? '').toUpperCase(),
                                      onChanged: (val) => setState(() => controller.selectEscortValue = val),
                                    )),
                                  ),
                                ],
                              )
                            : Row(
                                children: [
                                  Expanded(
                                    child: _labelledField('DEPT',
                                      _tab(19, _dropdown<DepartmentObject>(
                                        height: _fieldHeight,
                                        value: controller.selectDepartmentData,
                                        hint: 'SELECT DEPT',
                                        items: _departmentList,
                                        label: (item) => item.name ?? '',
                                        onChanged: _onDepartmentChanged,
                                      )),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: _labelledField('ESC',
                                      _tab(20, _dropdown<Escorts>(
                                        height: _fieldHeight,
                                        value: controller.selectEscortValue,
                                        hint: 'SELECT ESC',
                                        items: controller.escortList,
                                        label: (item) => (item.name ?? '').toUpperCase(),
                                        onChanged: (val) => setState(() => controller.selectEscortValue = val),
                                      )),
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
                                    _tab(21, _dropdown<PaymentTypeObject>(
                                      value: controller.selectPaymentTypeValue,
                                      hint: 'ACCOUNT',
                                      items: controller.dashboardAllData?.paymentTypes ?? [],
                                      label: (item) => item.name ?? '',
                                      onChanged: (val) => setState(() => controller.selectPaymentTypeValue = val),
                                    )),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      _tab(22, Focus(
                                        canRequestFocus: false,
                                        onKeyEvent: (node, event) {
                                          if (event is KeyDownEvent &&
                                              (event.logicalKey ==
                                                      LogicalKeyboardKey.enter ||
                                                  event.logicalKey ==
                                                      LogicalKeyboardKey.space)) {
                                            setState(() {
                                              controller.dropDownShow.value =
                                                  !controller.dropDownShow.value;
                                            });
                                            return KeyEventResult.handled;
                                          }
                                          return KeyEventResult.ignored;
                                        },
                                        child: SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: Checkbox(
                                            value: controller.dropDownShow.value,
                                            activeColor: DynamicColors.primaryClr,
                                            onChanged: (val) {
                                              setState(() {
                                                controller.dropDownShow.value =
                                                    val ?? false;
                                              });
                                            },
                                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                          ),
                                        ),
                                      )),
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
                                    child: _alertIconButtons(),
                                  ),
                                ],
                              )
                            : Row(
                                children: [
                                  Expanded(
                                    child: _labelledField('PAY',
                                      _tab(21, SizedBox(
                                        height: _fieldHeight,
                                        child: _dropdown<PaymentTypeObject>(
                                          height: _fieldHeight,
                                          value: controller.selectPaymentTypeValue,
                                          hint: 'ACCOUNT',
                                          items: controller.dashboardAllData?.paymentTypes ?? [],
                                          label: (item) => item.name ?? '',
                                          onChanged: (val) => setState(() => controller.selectPaymentTypeValue = val),
                                        ),
                                      )),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        _tab(22, Focus(
                                          canRequestFocus: false,
                                          onKeyEvent: (node, event) {
                                            if (event is KeyDownEvent &&
                                                (event.logicalKey ==
                                                        LogicalKeyboardKey.enter ||
                                                    event.logicalKey ==
                                                        LogicalKeyboardKey.space)) {
                                              setState(() {
                                                controller.dropDownShow.value =
                                                    !controller.dropDownShow.value;
                                              });
                                              return KeyEventResult.handled;
                                            }
                                            return KeyEventResult.ignored;
                                          },
                                          child: SizedBox(
                                            width: 18,
                                            height: 18,
                                            child: Checkbox(
                                              value: controller.dropDownShow.value,
                                              activeColor: DynamicColors.primaryClr,
                                              onChanged: (val) {
                                                setState(() {
                                                  controller.dropDownShow.value =
                                                      val ?? false;
                                                });
                                              },
                                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                            ),
                                          ),
                                        )),
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
                                      child: _alertIconButtons(),
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
                                          Obx(() => Text('ETA: ${controller.totalTimeDuration.value}', style: outFitRegular(fontSize: 11, fontWeight: FontWeight.bold))),
                                        ],
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.place_outlined,
                                              size: 14, color: _subtleText),
                                          const SizedBox(width: 3),
                                          Obx(() => Text('DISTANCE: ${controller.totalDistance.value}', style: outFitRegular(fontSize: 11, fontWeight: FontWeight.bold))),
                                        ],
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.payments_outlined,
                                              size: 14, color: _subtleText),
                                          const SizedBox(width: 3),
                                          Obx(() => Text('T/FARES: £ ${controller.fixedFare.value}', style: outFitRegular(fontSize: 11, fontWeight: FontWeight.bold))),
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
                                        child: _tab(23, TextField(textCapitalization: TextCapitalization.characters, inputFormatters: [UpperCaseTextFormatter()], 
                                            controller: controller.slugController,
                                            style: _valStyle,
                                            decoration: _fieldDec())),
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
                                      Obx(() => Text('ETA: ${controller.totalTimeDuration.value}', style: outFitRegular(fontSize: 11, fontWeight: FontWeight.bold))),
                                      const SizedBox(width: 14),
                                      const Icon(Icons.place_outlined, size: 14, color: _subtleText),
                                      const SizedBox(width: 3),
                                      Obx(() => Text('DISTANCE: ${controller.totalDistance.value}', style: outFitRegular(fontSize: 11, fontWeight: FontWeight.bold))),
                                      const SizedBox(width: 14),
                                      const Icon(Icons.payments_outlined,
                                          size: 14, color: _subtleText),
                                      const SizedBox(width: 3),
                                      Obx(() => Text('T/FARES: £ ${controller.fixedFare.value}', style: outFitRegular(fontSize: 11, fontWeight: FontWeight.bold))),
                                    ],
                                  ),
                                  const Spacer(),
                                  // Right aligned FARE input section
                                  Text('FARE  ', style: outFitRegular(fontSize: 11, fontWeight: FontWeight.bold)),
                                  SizedBox(
                                    width: 80,
                                    height: 30,
                                    child: _tab(23, TextField(textCapitalization: TextCapitalization.characters, inputFormatters: [UpperCaseTextFormatter()], 
                                        controller: controller.slugController,
                                        style: _valStyle,
                                        decoration: _fieldDec())),
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
                          child: _tab(24, _dropdown<DashboardDriverObject>(
                            height: 38,
                            value: controller.selectDriverValue,
                            hint: 'SELECT DRIVER',
                            items: controller.dashboardAllData?.drivers ?? [],
                            label: (item) => item.name ?? '',
                            onChanged: (val) => setState(() => controller.checkDriverSinBinStatus(val)),
                          )),
                        ),
                        const Spacer(flex: 3),
                        Expanded(
                          flex: 3,
                          child: SizedBox(
                            height: 38,
                            child: _tab(25, ElevatedButton(
                              onPressed: _saveSelectedReservations,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: DynamicColors.primaryClr,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6)),
                              ),
                              child: Text('SAVE', style: mozillaTextSemiBoldText(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white)),
                            )),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        )),
    );
  }

  /// SETTINGS, CHILD SEATS and EXTRA INFO — the same three icon buttons (and
  /// alerts) that sit after QUOTATION on the dashboard booking form, spread
  /// across the grey box beside QUOTATION. Tab stops fall between QUOTATION
  /// (22) and FARE (23).
  Widget _alertIconButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _alertIconBtn(Icons.settings_suggest, 22.2,
            () => showDialog(context: context, builder: (_) => SettingsDialog())),
        _alertIconBtn(Icons.attach_money, 22.4,
            () => showDialog(context: context, builder: (_) => ChildSeatsAlert())),
        _alertIconBtn(Icons.sticky_note_2, 22.6,
            () => showDialog(context: context, builder: (_) => ExtraInfoAlert())),
      ],
    );
  }

  /// One icon button, styled and keyboard-driven like the dashboard form's
  /// iconBtn: Enter / Space open the alert, GlowFocus rings it on focus.
  Widget _alertIconBtn(IconData icon, double tab, VoidCallback onPressed) {
    return _tab(tab, GlowFocus(
      child: Focus(
        // Key handling only: the IconButton inside is the single Tab stop.
        canRequestFocus: false,
        onKeyEvent: (node, event) {
          if (event is KeyDownEvent &&
              (event.logicalKey == LogicalKeyboardKey.enter ||
                  event.logicalKey == LogicalKeyboardKey.space)) {
            onPressed();
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFEEF2FF),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.black),
          ),
          child: IconButton(
            onPressed: onPressed,
            padding: const EdgeInsets.all(3),
            // Small enough to sit inside the 32–34px grey box.
            constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
            splashRadius: 16,
            icon: Icon(icon, size: 16, color: Colors.black),
          ),
        ),
      ),
    ));
  }

  // Helpers
  /// Tab-key order: fields are visited 1, 2, 3 ... top to bottom, left to right.
  Widget _tab(double order, Widget child) =>
      FocusTraversalOrder(order: NumericFocusOrder(order), child: child);

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
    String searchFieldName,
    TextEditingController ctrl,
    TextEditingController noteCtrl,
    String noteHint,
    IconData actionIcon,
    ZoneObject? zoneValue,
    List<ZoneObject> zoneList,
    ValueChanged<ZoneObject?> onZoneChanged,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 600;
        final double tabBase = label == 'PICK' ? 1 : 4;

        Widget buildSuffixIcons() {
          return Row(
            // Pinned to the right end whether or not the ✕ is showing.
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1st Icon: Clear (✕) — only while the field has text, the
              // same as the dashboard form. Tab stop right after the address.
              // The wrapper only draws the focus border; the IconButton
              // inside is the single Tab stop.
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: ctrl,
                builder: (context, value, _) => value.text.isEmpty
                    ? const SizedBox.shrink()
                    : _tab(tabBase + 0.3, Focus(
                canRequestFocus: false,
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
                        tooltip: 'Clear',
                        icon: const Icon(Icons.close,
                            size: 16, color: _subtleText),
                        onPressed: () {
                          _clearLocation(searchFieldName);
                          (label == 'PICK' ? _pickupFocusNode : _dropFocusNode)
                              .requestFocus();
                        },
                        padding: EdgeInsets.zero,
                        constraints:
                            const BoxConstraints(minWidth: 24, minHeight: 24),
                      ),
                    );
                  },
                ),
              ))),
              const SizedBox(width: 6),
              // 2nd Icon: Action Icon (Arrow/Route) — next Tab stop.
              _tab(tabBase + 0.6, Focus(
                canRequestFocus: false,
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
                        tooltip: label == 'DROP' ? 'Via locations' : null,
                        icon: Icon(actionIcon, size: 15, color: _subtleText),
                        // DROP's route icon opens the via-points dialog, the
                        // same as the dashboard form.
                        onPressed: label == 'DROP' ? _openViaLocations : () {},
                        padding: EdgeInsets.zero,
                        constraints:
                            const BoxConstraints(minWidth: 24, minHeight: 24),
                      ),
                    );
                  },
                ),
              )),
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
                  _searchLoader(searchFieldName),
                  Expanded(
                    child: SizedBox(
                      height: 34,
                      child: _tab(tabBase + 0, _addressField(
                        ctrl,
                        searchFieldName,
                        _fieldDec().copyWith(
                          suffixIcon: buildSuffixIcons(),
                          suffixIconConstraints:
                              const BoxConstraints(minWidth: 55),
                        ),
                      )),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: _tab(tabBase + 1, _dropdown<ZoneObject>(
                      height: 34,
                      value: zoneValue,
                      hint: 'SELECT ZONE',
                      items: zoneList,
                      label: (item) => item.name ?? '',
                      onChanged: onZoneChanged,
                    )),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: SizedBox(
                      height: 34,
                      child: _tab(tabBase + 2, TextField(textCapitalization: TextCapitalization.characters, inputFormatters: [UpperCaseTextFormatter()], 
                        controller: noteCtrl,
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
                      )),
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
            _searchLoader(searchFieldName),
            Expanded(
              flex: 5,
              child: SizedBox(
                height: 34,
                child: _tab(tabBase + 0, _addressField(
                  ctrl,
                  searchFieldName,
                  _fieldDec().copyWith(
                    suffixIcon: buildSuffixIcons(),
                    suffixIconConstraints: const BoxConstraints(minWidth: 55),
                  ),
                )),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 162,
              child: _tab(tabBase + 1, _dropdown<ZoneObject>(
                height: 34,
                value: zoneValue,
                hint: 'SELECT ZONE',
                items: zoneList,
                label: (item) => item.name ?? '',
                onChanged: onZoneChanged,
              )),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 162,
              height: 34,
              child: _tab(tabBase + 2, TextField(textCapitalization: TextCapitalization.characters, inputFormatters: [UpperCaseTextFormatter()], 
                controller: noteCtrl,
                style: outFitRegular(fontSize: 12),
                decoration: _fieldDec().copyWith(
                  hintText: noteHint,
                  hintStyle: outFitRegular(fontSize: 9, color: Colors.grey),
                  prefixIcon: const Icon(Icons.directions_car,
                      size: 14, color: _subtleText),
                  prefixIconConstraints: const BoxConstraints(minWidth: 24),
                ),
              )),
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
    final now = controller.pickUpDate ?? DateTime.now();
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

  Widget _timePickerBox(TextEditingController timeCtrl) {
    return SizedBox(
      height: 32,
      child: TimePickerField(
        controller: timeCtrl,
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
      itemLabel: (item) => label(item).toUpperCase(),
      onChanged: onChanged,
    );
  }
}
