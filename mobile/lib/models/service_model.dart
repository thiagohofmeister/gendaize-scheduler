import 'package:mobile/utils/parse_utils.dart';

import 'enums/service_type.dart';

class ServiceModel {
  String id;
  String name;
  double price;
  ServiceType type;
  int sameTimeQuantity;
  int duration;

  ServiceModel({
    required this.id,
    required this.name,
    required this.price,
    required this.type,
    required this.sameTimeQuantity,
    required this.duration,
  });

  ServiceModel.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        price = double.parse(map['price'].toString()),
        type = ServiceTypeExtension.fromString(map['type']),
        sameTimeQuantity = int.parse(map['sameTimeQuantity'].toString()),
        duration = int.parse(map['duration'].toString());

  String getDuration() {
    return ParseUtils.minutesToTime(duration);
  }

  String getAmount() {
    return ParseUtils.toMoney(price);
  }
}
