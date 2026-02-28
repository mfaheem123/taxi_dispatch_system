// To parse this JSON data, do
//
//     final updateInvoiceByIdModel = updateInvoiceByIdModelFromJson(jsonString);

import 'dart:convert';

import 'package:intl/intl.dart';

UpdateInvoiceByIdModel updateInvoiceByIdModelFromJson(String str) => UpdateInvoiceByIdModel.fromJson(json.decode(str));

String updateInvoiceByIdModelToJson(UpdateInvoiceByIdModel data) => json.encode(data.toJson());

class UpdateInvoiceByIdModel {
  UpdateInvoiceByIdModelAccountInvoice? accountInvoice;

  UpdateInvoiceByIdModel({
    this.accountInvoice,
  });

  factory UpdateInvoiceByIdModel.fromJson(Map<String, dynamic> json) => UpdateInvoiceByIdModel(
    accountInvoice: json["account_invoice"] == null ? null : UpdateInvoiceByIdModelAccountInvoice.fromJson(json["account_invoice"]),
  );

  Map<String, dynamic> toJson() => {
    "account_invoice": accountInvoice?.toJson(),
  };
}

class UpdateInvoiceByIdModelAccountInvoice {
  bool? status;
  AccountInvoiceAccountInvoice? accountInvoice;

  UpdateInvoiceByIdModelAccountInvoice({
    this.status,
    this.accountInvoice,
  });

  factory UpdateInvoiceByIdModelAccountInvoice.fromJson(Map<String, dynamic> json) => UpdateInvoiceByIdModelAccountInvoice(
    status: json["status"],
    accountInvoice: json["account_invoice"] == null ? null : AccountInvoiceAccountInvoice.fromJson(json["account_invoice"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "account_invoice": accountInvoice?.toJson(),
  };
}

class AccountInvoiceAccountInvoice {
  int? id;
  int? subsidiaryId;
  int? accountId;
  String? invoiceNumber;
  DateTime? invoiceDate;
  DateTime? invoiceDueDate;
  DateTime? fromDate;
  DateTime? toDate;
  String? invoiceType;
  int? departmentId;
  String? orderNumber;
  String? amount;
  String? status;
  String? createdAt;
  String? updatedAt;
  dynamic stripeCustomerId;
  dynamic stripePaymentId;
  Account? account;
  AccountDepartment? accountDepartment;
  List<AccountInvoiceLineitem>? accountInvoiceLineitems;

  AccountInvoiceAccountInvoice({
    this.id,
    this.subsidiaryId,
    this.accountId,
    this.invoiceNumber,
    this.invoiceDate,
    this.invoiceDueDate,
    this.fromDate,
    this.toDate,
    this.invoiceType,
    this.departmentId,
    this.orderNumber,
    this.amount,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.stripeCustomerId,
    this.stripePaymentId,
    this.account,
    this.accountDepartment,
    this.accountInvoiceLineitems,
  });

  factory AccountInvoiceAccountInvoice.fromJson(Map<String, dynamic> json) => AccountInvoiceAccountInvoice(
    id: json["id"],
    subsidiaryId: json["subsidiary_id"],
    accountId: json["account_id"],
    invoiceNumber: json["invoice_number"],
    invoiceDate: json["invoice_date"] != null
        ? DateFormat("yyyy-M-d").parse(json["invoice_date"])
        : null,
    invoiceDueDate: json["invoice_due_date"] != null
        ? DateFormat("yyyy-M-d").parse(json["invoice_due_date"])
        : null,
    fromDate: json["from_date"] != null
        ? DateFormat("yyyy-M-d").parse(json["from_date"])
        : null,
    toDate: json["to_date"] != null
        ? DateFormat("yyyy-M-d").parse(json["to_date"])
        : null,
    invoiceType: json["invoice_type"],
    departmentId: json["department_id"],
    orderNumber: json["order_number"],
    amount: json["amount"],
    status: json["status"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    stripeCustomerId: json["stripe_customer_id"],
    stripePaymentId: json["stripe_payment_id"],
    account: json["account"] == null ? null : Account.fromJson(json["account"]),
    accountDepartment: json["account_department"] == null ? null : AccountDepartment.fromJson(json["account_department"]),
    accountInvoiceLineitems: json["account_invoice_lineitems"] == null ? [] : List<AccountInvoiceLineitem>.from(json["account_invoice_lineitems"]!.map((x) => AccountInvoiceLineitem.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "subsidiary_id": subsidiaryId,
    "account_id": accountId,
    "invoice_number": invoiceNumber,
    "invoice_date": "${invoiceDate!.year.toString().padLeft(4, '0')}-${invoiceDate!.month.toString().padLeft(2, '0')}-${invoiceDate!.day.toString().padLeft(2, '0')}",
    "invoice_due_date": "${invoiceDueDate!.year.toString().padLeft(4, '0')}-${invoiceDueDate!.month.toString().padLeft(2, '0')}-${invoiceDueDate!.day.toString().padLeft(2, '0')}",
    "from_date": "${fromDate!.year.toString().padLeft(4, '0')}-${fromDate!.month.toString().padLeft(2, '0')}-${fromDate!.day.toString().padLeft(2, '0')}",
    "to_date": "${toDate!.year.toString().padLeft(4, '0')}-${toDate!.month.toString().padLeft(2, '0')}-${toDate!.day.toString().padLeft(2, '0')}",
    "invoice_type": invoiceType,
    "department_id": departmentId,
    "order_number": orderNumber,
    "amount": amount,
    "status": status,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "stripe_customer_id": stripeCustomerId,
    "stripe_payment_id": stripePaymentId,
    "account": account?.toJson(),
    "account_department": accountDepartment?.toJson(),
    "account_invoice_lineitems": accountInvoiceLineitems == null ? [] : List<dynamic>.from(accountInvoiceLineitems!.map((x) => x.toJson())),
  };
}

class Account {
  int? id;
  int? subsidiaryId;
  dynamic subsidiaryBankAccountId;
  String? accountType;
  bool? closed;
  String? name;
  String? code;
  String? email;
  String? password;
  String? mobile;
  String? telephone;
  String? fax;
  String? website;
  String? accountNumber;
  String? creditCard;
  String? address;
  String? paymentTypes;
  String? information;
  String? contactName;
  String? backgroundColor;
  String? foregroundColor;
  String? agentCommissionType;
  int? agentCommission;
  String? adminFeesType;
  int? adminFees;
  String? accountFeesType;
  int? accountFees;
  bool? hasBookedBy;
  bool? fareController;
  bool? hasEscort;
  bool? hasVat;
  bool? adminFeesVat;
  bool? accountFeesVat;
  bool? hasOrderNumber;
  bool? dispatchCustomerText;
  bool? confirmationText;
  bool? arrivalText;
  bool? clearJobText;
  bool? bankInformation;
  Subsidiary? subsidiary;

  Account({
    this.id,
    this.subsidiaryId,
    this.subsidiaryBankAccountId,
    this.accountType,
    this.closed,
    this.name,
    this.code,
    this.email,
    this.password,
    this.mobile,
    this.telephone,
    this.fax,
    this.website,
    this.accountNumber,
    this.creditCard,
    this.address,
    this.paymentTypes,
    this.information,
    this.contactName,
    this.backgroundColor,
    this.foregroundColor,
    this.agentCommissionType,
    this.agentCommission,
    this.adminFeesType,
    this.adminFees,
    this.accountFeesType,
    this.accountFees,
    this.hasBookedBy,
    this.fareController,
    this.hasEscort,
    this.hasVat,
    this.adminFeesVat,
    this.accountFeesVat,
    this.hasOrderNumber,
    this.dispatchCustomerText,
    this.confirmationText,
    this.arrivalText,
    this.clearJobText,
    this.bankInformation,
    this.subsidiary,
  });

  factory Account.fromJson(Map<String, dynamic> json) => Account(
    id: json["id"],
    subsidiaryId: json["subsidiary_id"],
    subsidiaryBankAccountId: json["subsidiary_bank_account_id"],
    accountType: json["account_type"],
    closed: json["closed"],
    name: json["name"],
    code: json["code"],
    email: json["email"],
    password: json["password"],
    mobile: json["mobile"],
    telephone: json["telephone"],
    fax: json["fax"],
    website: json["website"],
    accountNumber: json["account_number"],
    creditCard: json["credit_card"],
    address: json["address"],
    paymentTypes: json["payment_types"],
    information: json["information"],
    contactName: json["contact_name"],
    backgroundColor: json["background_color"],
    foregroundColor: json["foreground_color"],
    agentCommissionType: json["agent_commission_type"],
    agentCommission: json["agent_commission"],
    adminFeesType: json["admin_fees_type"],
    adminFees: json["admin_fees"],
    accountFeesType: json["account_fees_type"],
    accountFees: json["account_fees"],
    hasBookedBy: json["has_booked_by"],
    fareController: json["fare_controller"],
    hasEscort: json["has_escort"],
    hasVat: json["has_vat"],
    adminFeesVat: json["admin_fees_vat"],
    accountFeesVat: json["account_fees_vat"],
    hasOrderNumber: json["has_order_number"],
    dispatchCustomerText: json["dispatch_customer_text"],
    confirmationText: json["confirmation_text"],
    arrivalText: json["arrival_text"],
    clearJobText: json["clear_job_text"],
    bankInformation: json["bank_information"],
    subsidiary: json["subsidiary"] == null ? null : Subsidiary.fromJson(json["subsidiary"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "subsidiary_id": subsidiaryId,
    "subsidiary_bank_account_id": subsidiaryBankAccountId,
    "account_type": accountType,
    "closed": closed,
    "name": name,
    "code": code,
    "email": email,
    "password": password,
    "mobile": mobile,
    "telephone": telephone,
    "fax": fax,
    "website": website,
    "account_number": accountNumber,
    "credit_card": creditCard,
    "address": address,
    "payment_types": paymentTypes,
    "information": information,
    "contact_name": contactName,
    "background_color": backgroundColor,
    "foreground_color": foregroundColor,
    "agent_commission_type": agentCommissionType,
    "agent_commission": agentCommission,
    "admin_fees_type": adminFeesType,
    "admin_fees": adminFees,
    "account_fees_type": accountFeesType,
    "account_fees": accountFees,
    "has_booked_by": hasBookedBy,
    "fare_controller": fareController,
    "has_escort": hasEscort,
    "has_vat": hasVat,
    "admin_fees_vat": adminFeesVat,
    "account_fees_vat": accountFeesVat,
    "has_order_number": hasOrderNumber,
    "dispatch_customer_text": dispatchCustomerText,
    "confirmation_text": confirmationText,
    "arrival_text": arrivalText,
    "clear_job_text": clearJobText,
    "bank_information": bankInformation,
    "subsidiary": subsidiary?.toJson(),
  };
}

class Subsidiary {
  int? id;
  String? name;
  String? logo;
  String? backgroundColor;
  String? foregroundColor;
  String? telephoneNumber;
  String? emergencyContactNumber;
  String? email;
  String? fax;
  String? website;
  String? address;
  String? sortCode;
  String? accountNumber;
  String? accountTitle;
  String? bank;
  String? companyNumber;
  String? vatNumber;
  String? iban;
  double? balance;
  String? currency;
  String? webAccessToken;
  String? mobileAccessToken;
  int? maximumDrivers;
  int? activeDrivers;
  double? addressLatitude;
  double? addressLongitude;

  Subsidiary({
    this.id,
    this.name,
    this.logo,
    this.backgroundColor,
    this.foregroundColor,
    this.telephoneNumber,
    this.emergencyContactNumber,
    this.email,
    this.fax,
    this.website,
    this.address,
    this.sortCode,
    this.accountNumber,
    this.accountTitle,
    this.bank,
    this.companyNumber,
    this.vatNumber,
    this.iban,
    this.balance,
    this.currency,
    this.webAccessToken,
    this.mobileAccessToken,
    this.maximumDrivers,
    this.activeDrivers,
    this.addressLatitude,
    this.addressLongitude,
  });

  factory Subsidiary.fromJson(Map<String, dynamic> json) => Subsidiary(
    id: json["id"],
    name: json["name"],
    logo: json["logo"],
    backgroundColor: json["background_color"],
    foregroundColor: json["foreground_color"],
    telephoneNumber: json["telephone_number"],
    emergencyContactNumber: json["emergency_contact_number"],
    email: json["email"],
    fax: json["fax"],
    website: json["website"],
    address: json["address"],
    sortCode: json["sort_code"],
    accountNumber: json["account_number"],
    accountTitle: json["account_title"],
    bank: json["bank"],
    companyNumber: json["company_number"],
    vatNumber: json["vat_number"],
    iban: json["iban"],
    balance: json["balance"]?.toDouble(),
    currency: json["currency"],
    webAccessToken: json["web_access_token"],
    mobileAccessToken: json["mobile_access_token"],
    maximumDrivers: json["maximum_drivers"],
    activeDrivers: json["active_drivers"],
    addressLatitude: json["address_latitude"]?.toDouble(),
    addressLongitude: json["address_longitude"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "logo": logo,
    "background_color": backgroundColor,
    "foreground_color": foregroundColor,
    "telephone_number": telephoneNumber,
    "emergency_contact_number": emergencyContactNumber,
    "email": email,
    "fax": fax,
    "website": website,
    "address": address,
    "sort_code": sortCode,
    "account_number": accountNumber,
    "account_title": accountTitle,
    "bank": bank,
    "company_number": companyNumber,
    "vat_number": vatNumber,
    "iban": iban,
    "balance": balance,
    "currency": currency,
    "web_access_token": webAccessToken,
    "mobile_access_token": mobileAccessToken,
    "maximum_drivers": maximumDrivers,
    "active_drivers": activeDrivers,
    "address_latitude": addressLatitude,
    "address_longitude": addressLongitude,
  };
}

class AccountDepartment {
  int? id;
  String? name;

  AccountDepartment({
    this.id,
    this.name,
  });

  factory AccountDepartment.fromJson(Map<String, dynamic> json) => AccountDepartment(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}

class AccountInvoiceLineitem {
  int? id;
  Booking? booking;
  int? bookingId;
  int? accountInvoiceId;

  AccountInvoiceLineitem({
    this.id,
    this.booking,
    this.bookingId,
    this.accountInvoiceId,
  });

  factory AccountInvoiceLineitem.fromJson(Map<String, dynamic> json) => AccountInvoiceLineitem(
    id: json["id"],
    booking: json["booking"] == null ? null : Booking.fromJson(json["booking"]),
    bookingId: json["booking_id"],
    accountInvoiceId: json["account_invoice_id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "booking": booking?.toJson(),
    "booking_id": bookingId,
    "account_invoice_id": accountInvoiceId,
  };
}

class Booking {
  int? id;
  String? name;
  String? pickup;
  String? dropoff;
  String? viapoints;
  String? department;
  String? pickupDate;
  String? pickupTime;
  JourneyType? journeyType;
  dynamic orderNumber;
  AccountDepartment? paymentType;
  VehicleType? vehicleType;
  double? companyPrice;
  double? totalCharges;
  double? meetAndGreet;
  double? parkingCharges;
  double? waitingCharges;
  String? referenceNumber;
  double? congestionCharges;
  double? extraDropCharges;

  Booking({
    this.id,
    this.name,
    this.pickup,
    this.dropoff,
    this.viapoints,
    this.department,
    this.pickupDate,
    this.pickupTime,
    this.journeyType,
    this.orderNumber,
    this.paymentType,
    this.vehicleType,
    this.companyPrice,
    this.totalCharges,
    this.meetAndGreet,
    this.parkingCharges,
    this.waitingCharges,
    this.referenceNumber,
    this.congestionCharges,
    this.extraDropCharges,
  });

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
    id: json["id"],
    name: json["name"],
    pickup: json["pickup"],
    dropoff: json["dropoff"],
    viapoints: json["viapoints"],
    department: json["department"],
    pickupDate: json["pickup_date"],
    pickupTime: json["pickup_time"],
    journeyType: json["journey_type"] == null ? null : JourneyType.fromJson(json["journey_type"]),
    orderNumber: json["order_number"],
    paymentType: json["payment_type"] == null ? null : AccountDepartment.fromJson(json["payment_type"]),
    vehicleType: json["vehicle_type"] == null ? null : VehicleType.fromJson(json["vehicle_type"]),
    companyPrice: json["company_price"],
    totalCharges: json["total_charges"],
    meetAndGreet: json["meet_and_greet"],
    parkingCharges: json["parking_charges"],
    waitingCharges: json["waiting_charges"],
    referenceNumber: json["reference_number"],
    congestionCharges: json["congestion_charges"],
    extraDropCharges: json["extra_drop_charges"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "pickup": pickup,
    "dropoff": dropoff,
    "viapoints": viapoints,
    "department": department,
    "pickup_date": pickupDate,
    "pickup_time": pickupTime,
    "journey_type": journeyType?.toJson(),
    "order_number": orderNumber,
    "payment_type": paymentType?.toJson(),
    "vehicle_type": vehicleType?.toJson(),
    "company_price": companyPrice,
    "total_charges": totalCharges,
    "meet_and_greet": meetAndGreet,
    "parking_charges": parkingCharges,
    "waiting_charges": waitingCharges,
    "reference_number": referenceNumber,
    "congestion_charges": congestionCharges,
    "extra_drop_charges": extraDropCharges,
  };
}

class JourneyType {
  String? journeyType;

  JourneyType({
    this.journeyType,
  });

  factory JourneyType.fromJson(Map<String, dynamic> json) => JourneyType(
    journeyType: json["journey_type"],
  );

  Map<String, dynamic> toJson() => {
    "journey_type": journeyType,
  };
}

class VehicleType {
  String? name;

  VehicleType({
    this.name,
  });

  factory VehicleType.fromJson(Map<String, dynamic> json) => VehicleType(
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
  };
}
