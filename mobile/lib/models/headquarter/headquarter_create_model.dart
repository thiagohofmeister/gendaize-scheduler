import 'package:mobile/models/shared/address_model.dart';
import 'package:mobile/models/headquarter/headquarter_schedule_model.dart';

class HeadquarterCreateModel {
  String name;
  AddressModel address;
  List<HeadquarterScheduleModel>? schedules;
  List<String>? locationIds;

  HeadquarterCreateModel({
    required this.name,
    required this.address,
    this.schedules,
    this.locationIds,
  });

  HeadquarterCreateModel.fromMap(Map<String, dynamic> map)
      : name = map['name'],
        address = AddressModel.fromMap(map['address']),
        schedules = map['schedules'] != null
            ? HeadquarterScheduleModel.fromMapList(map['schedules'])
            : null,
        locationIds = map['locations']
            ?.map((location) => location['id'] as String)
            .toList();

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address.toMap(),
      'schedules': schedules != null
          ? schedules!.map((schedule) => schedule.toMap()).toList()
          : null,
      'locations': locationIds != null
          ? locationIds!.map((location) => ({
                'id': location,
              }))
          : null
    };
  }
}
