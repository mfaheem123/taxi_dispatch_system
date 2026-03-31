class DriverActivityModel {
  int? id;
  String? name;
  String? username;
  String? zone;
  String? vehicleType;
  DateTime? lastLoginAt;

  DriverActivityModel({
    this.id,
    this.name,
    this.username,
    this.zone,
    this.vehicleType,
    this.lastLoginAt,
  });

  factory DriverActivityModel.fromJson(Map<String, dynamic> json) {
    return DriverActivityModel(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      zone: json['zone'],
      vehicleType: json['vehicle_type'],
      lastLoginAt: json['last_login_at'] != null
          ? DateTime.parse(json['last_login_at']).toLocal()
          : null,
    );
  }
}