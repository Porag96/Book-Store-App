import 'dart:math';

class AddressDataModel {
  String? name;
  String? phoneNumber;
  String? houseNumber;
  String? city;
  String? state;
  String? pincode;

  AddressDataModel({
    this.name,
    this.phoneNumber,
    this.houseNumber,
    this.city,
    this.state,
    this.pincode,
  });

  AddressDataModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phoneNumber = json['phoneNumber'];
    houseNumber = json['houseNumber'];
    city = json['city'];
    state = json['state'];
    pincode = json['pincode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = this.name;
    data['phoneNumber'] = this.phoneNumber;
    data['houseNumber'] = this.houseNumber;
    data['city'] = this.city;
    data['state'] = this.state;
    data['pincode'] = this.pincode;
    return data;
  }
}
