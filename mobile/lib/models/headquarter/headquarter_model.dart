import 'package:mobile/models/location/location_model.dart';
import 'package:mobile/models/shared/address_model.dart';

class HeadquarterModel {
  String id;
  String name;
  AddressModel address;
  List<LocationModel> locations;

  HeadquarterModel({
    required this.id,
    required this.name,
    required this.address,
    required this.locations,
  });

  HeadquarterModel.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        address = AddressModel.fromMap(map['address']),
        locations = LocationModel.fromList(map['locations']);
}
