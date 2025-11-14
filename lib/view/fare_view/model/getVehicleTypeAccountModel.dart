// To parse this JSON data, do
//
//     final fareGetVehicleTypeAccount = fareGetVehicleTypeAccountFromJson(jsonString);

import 'dart:convert';

FareGetVehicleTypeAccount fareGetVehicleTypeAccountFromJson(String str) => FareGetVehicleTypeAccount.fromJson(json.decode(str));

String fareGetVehicleTypeAccountToJson(FareGetVehicleTypeAccount data) => json.encode(data.toJson());

class FareGetVehicleTypeAccount {
  bool? status;
  String? message;
  int? vehicleTypesCount;
  int? accountsCount;
  List<VehicleTypeConfiguration>? vehicleTypes;
  List<Account>? accounts;

  FareGetVehicleTypeAccount({
    this.status,
    this.message,
    this.vehicleTypesCount,
    this.accountsCount,
    this.vehicleTypes,
    this.accounts,
  });

  factory FareGetVehicleTypeAccount.fromJson(Map<String, dynamic> json) => FareGetVehicleTypeAccount(
    status: json["status"],
    message: json["message"],
    vehicleTypesCount: json["vehicle_types_count"],
    accountsCount: json["accounts_count"],
    vehicleTypes: json["vehicle_types"] == null ? [] : List<VehicleTypeConfiguration>.from(json["vehicle_types"]!.map((x) => VehicleTypeConfiguration.fromJson(x))),
    accounts: json["accounts"] == null ? [] : List<Account>.from(json["accounts"]!.map((x) => Account.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "vehicle_types_count": vehicleTypesCount,
    "accounts_count": accountsCount,
    "vehicle_types": vehicleTypes == null ? [] : List<dynamic>.from(vehicleTypes!.map((x) => x.toJson())),
    "accounts": accounts == null ? [] : List<dynamic>.from(accounts!.map((x) => x.toJson())),
  };
}



class Account {
  int? id;
  String? name;
  String? code;
  AccountType? accountType;

  Account({
    this.id,
    this.name,
    this.code,
    this.accountType,
  });

  factory Account.fromJson(Map<String, dynamic> json) => Account(
    id: json["id"],
    name: json["name"],
    code: json["code"],
    accountType: accountTypeValues.map[json["account_type"]]!,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "code": code,
    "account_type": accountTypeValues.reverse[accountType],
  };
}

enum AccountType {
  ACCOUNT,
  ACCOUNT_TYPE_CASH,
  CARD,
  CASH
}

final accountTypeValues = EnumValues({
  "Account": AccountType.ACCOUNT,
  "Cash": AccountType.ACCOUNT_TYPE_CASH,
  "card": AccountType.CARD,
  "cash": AccountType.CASH
});

class  VehicleTypeConfiguration {
  int? id;
  String? name;

  VehicleTypeConfiguration({
    this.id,
    this.name,
  });

  factory VehicleTypeConfiguration.fromJson(Map<String, dynamic> json) => VehicleTypeConfiguration(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
