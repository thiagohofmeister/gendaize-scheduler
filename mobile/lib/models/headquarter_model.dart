import 'package:mobile/models/address_model.dart';

class HeadquarterModel {
  String id;
  String name;
  AddressModel address;

  HeadquarterModel({
    required this.id,
    required this.name,
    required this.address,
  });

  HeadquarterModel.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        address = AddressModel.fromMap(map['address']);
}
