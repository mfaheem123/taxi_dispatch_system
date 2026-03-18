class DriverActivityModel {
  int? id;
  String? name;
  String? username;
  String? zone;
  String? vehicleType;

  DriverActivityModel({
    this.id,
    this.name,
    this.username,
    this.zone,
    this.vehicleType,
  });

  factory DriverActivityModel.fromJson(Map<String, dynamic> json) {
    return DriverActivityModel(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      zone: json['zone'],
      vehicleType: json['vehicle_type'],
    );
  }
}