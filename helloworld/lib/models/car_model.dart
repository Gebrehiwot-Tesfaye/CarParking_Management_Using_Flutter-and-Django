class CarModel {
  String carModel;
  String vehicleIdentificationNumber;

  CarModel({required this.carModel, required this.vehicleIdentificationNumber});

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      carModel: json['car_model'],
      vehicleIdentificationNumber: json['vehicle_identification_number'],
    );
  }
}
