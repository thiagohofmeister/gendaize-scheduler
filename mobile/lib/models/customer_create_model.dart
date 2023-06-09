import 'package:mobile/models/customer_address_create_model.dart';

class CustomerCreateModel {
  String name;
  String phone;
  String? email;
  List<CustomerAddressCreateModel>? addresses;

  CustomerCreateModel({
    required this.name,
    required this.phone,
    this.email,
    this.addresses,
  });
}
