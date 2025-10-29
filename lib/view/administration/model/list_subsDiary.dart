class SubsDiaryModel {
  bool? status;
  int? page;
  int? limit;
  int? total;
  int? totalPages;
  int? count;
  List<Subsidiaries>? subsidiaries;

  SubsDiaryModel(
      {this.status,
      this.page,
      this.limit,
      this.total,
      this.totalPages,
      this.count,
      this.subsidiaries});

  SubsDiaryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    page = json['page'];
    limit = json['limit'];
    total = json['total'];
    totalPages = json['total_pages'];
    count = json['count'];
    if (json['subsidiaries'] != null) {
      subsidiaries = <Subsidiaries>[];
      json['subsidiaries'].forEach((v) {
        subsidiaries!.add(new Subsidiaries.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['page'] = this.page;
    data['limit'] = this.limit;
    data['total'] = this.total;
    data['total_pages'] = this.totalPages;
    data['count'] = this.count;
    if (this.subsidiaries != null) {
      data['subsidiaries'] = this.subsidiaries!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Subsidiaries {
  int? id;
  String? logo;
  String? backgroundColor;
  String? foregroundColor;
  String? name;
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
  String? balance;
  String? currency;
  String? webAccessToken;
  String? mobileAccessToken;
  int? maximumDrivers;
  int? activeDrivers;
  double? addressLatitude;
  double? addressLongitude;
  String? createdAt;
  String? updatedAt;

  Subsidiaries(
      {this.id,
      this.logo,
      this.backgroundColor,
      this.foregroundColor,
      this.name,
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
      this.createdAt,
      this.updatedAt});

  Subsidiaries.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    logo = json['logo'];
    backgroundColor = json['background_color'];
    foregroundColor = json['foreground_color'];
    name = json['name'];
    telephoneNumber = json['telephone_number'];
    emergencyContactNumber = json['emergency_contact_number'];
    email = json['email'];
    fax = json['fax'];
    website = json['website'];
    address = json['address'];
    sortCode = json['sort_code'];
    accountNumber = json['account_number'];
    accountTitle = json['account_title'];
    bank = json['bank'];
    companyNumber = json['company_number'];
    vatNumber = json['vat_number'];
    iban = json['iban'];
    balance = json['balance'];
    currency = json['currency'];
    webAccessToken = json['web_access_token'];
    mobileAccessToken = json['mobile_access_token'];
    maximumDrivers = json['maximum_drivers'];
    activeDrivers = json['active_drivers'];
    addressLatitude = json['address_latitude'];
    addressLongitude = json['address_longitude'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['logo'] = this.logo;
    data['background_color'] = this.backgroundColor;
    data['foreground_color'] = this.foregroundColor;
    data['name'] = this.name;
    data['telephone_number'] = this.telephoneNumber;
    data['emergency_contact_number'] = this.emergencyContactNumber;
    data['email'] = this.email;
    data['fax'] = this.fax;
    data['website'] = this.website;
    data['address'] = this.address;
    data['sort_code'] = this.sortCode;
    data['account_number'] = this.accountNumber;
    data['account_title'] = this.accountTitle;
    data['bank'] = this.bank;
    data['company_number'] = this.companyNumber;
    data['vat_number'] = this.vatNumber;
    data['iban'] = this.iban;
    data['balance'] = this.balance;
    data['currency'] = this.currency;
    data['web_access_token'] = this.webAccessToken;
    data['mobile_access_token'] = this.mobileAccessToken;
    data['maximum_drivers'] = this.maximumDrivers;
    data['active_drivers'] = this.activeDrivers;
    data['address_latitude'] = this.addressLatitude;
    data['address_longitude'] = this.addressLongitude;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
