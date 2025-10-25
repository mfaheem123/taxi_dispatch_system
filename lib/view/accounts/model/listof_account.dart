class ListOfAccountModel {
  bool? status;
  int? page;
  int? limit;
  int? totalPages;
  int? count;
  List<AccountObject>? accounts;

  ListOfAccountModel({
    this.status,
    this.page,
    this.limit,
    this.totalPages,
    this.count,
    this.accounts,
  });

  factory ListOfAccountModel.fromJson(Map<String, dynamic> json) {
    return ListOfAccountModel(
      status: json['status'] == true ||
          json['status'] == 'true', // handle string "true"
      page: int.tryParse(json['page']?.toString() ?? '0'),
      limit: int.tryParse(json['limit']?.toString() ?? '0'),
      totalPages: int.tryParse(json['total_pages']?.toString() ?? '0'),
      count: int.tryParse(json['count']?.toString() ?? '0'),
      accounts: (json['accounts'] as List?)
          ?.map((e) => AccountObject.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "page": page,
        "limit": limit,
        "total_pages": totalPages,
        "count": count,
        "accounts": accounts?.map((x) => x.toJson()).toList(),
      };
}

class AccountObject {
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
  String? agentCommission;
  String? adminFeesType;
  String? adminFees;
  String? accountFeesType;
  String? accountFees;
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
  String? createdAt;
  String? updatedAt;
  List<Department>? departments;
  Subsidiary? subsidiary;

  AccountObject({
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
    this.createdAt,
    this.updatedAt,
    this.departments,
    this.subsidiary,
  });

  factory AccountObject.fromJson(Map<String, dynamic> json) {
    return AccountObject(
      id: int.tryParse(json['id']?.toString() ?? '0'),
      subsidiaryId: int.tryParse(json['subsidiary_id']?.toString() ?? '0'),
      subsidiaryBankAccountId: json['subsidiary_bank_account_id'],
      accountType: json['account_type'],
      closed: json['closed'] == true || json['closed'] == 'true',
      name: json['name'],
      code: json['code'],
      email: json['email'],
      password: json['password'],
      mobile: json['mobile'],
      telephone: json['telephone'],
      fax: json['fax'],
      website: json['website'],
      accountNumber: json['account_number'],
      creditCard: json['credit_card'],
      address: json['address'],
      paymentTypes: json['payment_types'],
      information: json['information'],
      contactName: json['contact_name'] ?? json['contactName'] ?? json['Contact_Name'] ?? json['contactname'],

      backgroundColor: json['background_color'],
      foregroundColor: json['foreground_color'],
      agentCommissionType: json['agent_commission_type'],
      agentCommission: json['agent_commission'],
      adminFeesType: json['admin_fees_type'],
      adminFees: json['admin_fees'],
      accountFeesType: json['account_fees_type'],
      accountFees: json['account_fees'],
      hasBookedBy: json['has_booked_by'] == true ||
          json['has_booked_by'] == true,
      fareController: json['fare_controller'] == true ||
          json['fare_controller'] == true,
      hasEscort: json['has_escort'] == true || json['has_escort'] == true,
      hasVat: json['has_vat'] == true || json['has_vat'] == true,
      adminFeesVat:
          json['admin_fees_vat'] == true || json['admin_fees_vat'] == true,
      accountFeesVat:
          json['account_fees_vat'] == true || json['account_fees_vat'] == true,
      hasOrderNumber: json['has_order_number'] == true ||
          json['has_order_number'] == true,
      dispatchCustomerText: json['dispatch_customer_text'] == true ||
          json['dispatch_customer_text'] == true,
      confirmationText: json['confirmation_text'] == true ||
          json['confirmation_text'] == true,
      arrivalText:
          json['arrival_text'] == true || json['arrival_text'] == true,
      clearJobText:
          json['clear_job_text'] == true || json['clear_job_text'] == true,
      bankInformation:
          json['bank_information'] == true || json['bank_information'] == true,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      departments: (json['departments'] as List?)
          ?.map((e) => Department.fromJson(e))
          .toList(),
      subsidiary: json['subsidiary'] != null
          ? Subsidiary.fromJson(json['subsidiary'])
          : null,
    );
  }

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
        "created_at": createdAt,
        "updated_at": updatedAt,
        "departments": departments?.map((x) => x.toJson()).toList(),
        "subsidiary": subsidiary?.toJson(),
      };
}

class Department {
  int? id;
  String? name;

  Department({this.id, this.name});

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      id: int.tryParse(json['id']?.toString() ?? '0'),
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class Subsidiary {
  int? id;
  String? name;
  String? email;
  String? telephoneNumber;

  Subsidiary({
    this.id,
    this.name,
    this.email,
    this.telephoneNumber,
  });

  factory Subsidiary.fromJson(Map<String, dynamic> json) {
    return Subsidiary(
      id: int.tryParse(json['id']?.toString() ?? '0'),
      name: json['name'],
      email: json['email'],
      telephoneNumber: json['telephone_number'],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "telephone_number": telephoneNumber,
      };
}
