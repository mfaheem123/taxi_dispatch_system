class Driver {
  // Personal Info
  bool hasPDA;
  bool rentPaid;
  bool isActive;
  String? company;
  String? username;
  String? password;
  String? fullName;
  String? dob;
  String? email;
  String? mobile;
  String? telephone;
  String? ni;
  String? driverType;
  String? commission;
  String? rentLimit;
  String? balance;
  String? address;

  // Vehicle Info
  bool useCompanyVehicle;
  String? companyVehicle;
  String? startDate;
  String? endDate;
  String? vehicleNo;
  String? make;
  String? model;
  String? color;
  String? vehicleType;
  String? owner;
  String? logBook;
  String? logBookDocument;

  Driver({
    this.hasPDA = false,
    this.rentPaid = false,
    this.isActive = false,
    this.company,
    this.username,
    this.password,
    this.fullName,
    this.dob,
    this.email,
    this.mobile,
    this.telephone,
    this.ni,
    this.driverType,
    this.commission,
    this.rentLimit,
    this.balance,
    this.address,
    this.useCompanyVehicle = false,
    this.companyVehicle,
    this.startDate,
    this.endDate,
    this.vehicleNo,
    this.make,
    this.model,
    this.color,
    this.vehicleType,
    this.owner,
    this.logBook,
    this.logBookDocument,
  });

  // Convert object → Map (for saving)
  Map<String, dynamic> toJson() {
    return {
      "hasPDA": hasPDA,
      "rentPaid": rentPaid,
      "isActive": isActive,
      "company": company,
      "username": username,
      "password": password,
      "fullName": fullName,
      "dob": dob,
      "email": email,
      "mobile": mobile,
      "telephone": telephone,
      "ni": ni,
      "driverType": driverType,
      "commission": commission,
      "rentLimit": rentLimit,
      "balance": balance,
      "address": address,
      "useCompanyVehicle": useCompanyVehicle,
      "companyVehicle": companyVehicle,
      "startDate": startDate,
      "endDate": endDate,
      "vehicleNo": vehicleNo,
      "make": make,
      "model": model,
      "color": color,
      "vehicleType": vehicleType,
      "owner": owner,
      "logBook": logBook,
      "logBookDocument": logBookDocument,
    };
  }

  // Convert Map → Object (for loading)
  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      hasPDA: json["hasPDA"] ?? false,
      rentPaid: json["rentPaid"] ?? false,
      isActive: json["isActive"] ?? false,
      company: json["company"],
      username: json["username"],
      password: json["password"],
      fullName: json["fullName"],
      dob: json["dob"],
      email: json["email"],
      mobile: json["mobile"],
      telephone: json["telephone"],
      ni: json["ni"],
      driverType: json["driverType"],
      commission: json["commission"],
      rentLimit: json["rentLimit"],
      balance: json["balance"],
      address: json["address"],
      useCompanyVehicle: json["useCompanyVehicle"] ?? false,
      companyVehicle: json["companyVehicle"],
      startDate: json["startDate"],
      endDate: json["endDate"],
      vehicleNo: json["vehicleNo"],
      make: json["make"],
      model: json["model"],
      color: json["color"],
      vehicleType: json["vehicleType"],
      owner: json["owner"],
      logBook: json["logBook"],
      logBookDocument: json["logBookDocument"],
    );
  }
}
