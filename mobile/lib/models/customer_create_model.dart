import 'package:mobile/models/customer_address_create_model.dart';

class CustomerCreateModel {
  String name;
  String phone;
  String? email;
  CustomerAddressCreateModel? address;

  CustomerCreateModel({
    required this.name,
    required this.phone,
    this.email,
    this.address,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'address': address?.toMap()
    };
  }
}
