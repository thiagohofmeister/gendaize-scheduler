import 'package:manager/models/shared/address_model.dart';

class CustomerModel {
  String id;
  String name;
  String phone;
  String? email;
  List<AddressModel> addresses;

  CustomerModel({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    required this.addresses,
  });

  CustomerModel.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        phone = map['phone'],
        email = map['email'],
        addresses = AddressModel.fromList(map['addresses']);
}
