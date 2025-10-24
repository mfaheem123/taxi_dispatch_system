class VehicleTypeModel {
  bool? status;
  int? page;
  int? limit;
  int? total;
  int? totalPages;
  int? count;
  List<VehicleTypes>? vehicleTypes;

  VehicleTypeModel(
      {this.status,
      this.page,
      this.limit,
      this.total,
      this.totalPages,
      this.count,
      this.vehicleTypes});

  VehicleTypeModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    page = json['page'];
    limit = json['limit'];
    total = json['total'];
    totalPages = json['total_pages'];
    count = json['count'];
    if (json['vehicle_types'] != null) {
      vehicleTypes = <VehicleTypes>[];
      json['vehicle_types'].forEach((v) {
        vehicleTypes!.add(new VehicleTypes.fromJson(v));
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
    if (this.vehicleTypes != null) {
      data['vehicle_types'] =
          this.vehicleTypes!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VehicleTypes {
  int? id;
  String? name;
  int? passengers;
  int? luggages;
  int? handLuggages;
  int? minimumFares;
  int? minimumMiles;
  int? waitingTime;
  int? waitingTimeDuration;
  bool? defaultVehicle;
  bool? vehicleTypeMinimumFares;
  String? image;
  String? createdAt;
  String? updatedAt;
  String? backgroundColor;
  String? foregroundColor;
  int? driverWaitingCharges;
  int? accountWaitingCharges;

  VehicleTypes(
      {this.id,
      this.name,
      this.passengers,
      this.luggages,
      this.handLuggages,
      this.minimumFares,
      this.minimumMiles,
      this.waitingTime,
      this.waitingTimeDuration,
      this.defaultVehicle,
      this.vehicleTypeMinimumFares,
      this.image,
      this.createdAt,
      this.updatedAt,
      this.backgroundColor,
      this.foregroundColor,
      this.driverWaitingCharges,
      this.accountWaitingCharges});

  VehicleTypes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    passengers = json['passengers'];
    luggages = json['luggages'];
    handLuggages = json['hand_luggages'];
    minimumFares = json['minimum_fares'];
    minimumMiles = json['minimum_miles'];
    waitingTime = json['waiting_time'];
    waitingTimeDuration = json['waiting_time_duration'];
    defaultVehicle = json['default_vehicle'];
    vehicleTypeMinimumFares = json['vehicle_type_minimum_fares'];
    image = json['image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    backgroundColor = json['background_color'];
    foregroundColor = json['foreground_color'];
    driverWaitingCharges = json['driver_waiting_charges'];
    accountWaitingCharges = json['account_waiting_charges'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['passengers'] = this.passengers;
    data['luggages'] = this.luggages;
    data['hand_luggages'] = this.handLuggages;
    data['minimum_fares'] = this.minimumFares;
    data['minimum_miles'] = this.minimumMiles;
    data['waiting_time'] = this.waitingTime;
    data['waiting_time_duration'] = this.waitingTimeDuration;
    data['default_vehicle'] = this.defaultVehicle;
    data['vehicle_type_minimum_fares'] = this.vehicleTypeMinimumFares;
    data['image'] = this.image;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['background_color'] = this.backgroundColor;
    data['foreground_color'] = this.foregroundColor;
    data['driver_waiting_charges'] = this.driverWaitingCharges;
    data['account_waiting_charges'] = this.accountWaitingCharges;
    return data;
  }
}
