import 'package:manager/utils/parse_utils.dart';

import '../enums/service_type.dart';

class ServiceModel {
  String id;
  String name;
  double? price;
  ServiceType? type;
  int? sameTimeQuantity;
  int? duration;

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
        price =
            map['price'] != null ? double.parse(map['price'].toString()) : 0,
        type = map['type'] != null
            ? ServiceTypeExtension.fromString(map['type'])
            : null,
        sameTimeQuantity = map['sameTimeQuantity'] != null
            ? int.parse(map['sameTimeQuantity'].toString())
            : null,
        duration = map['duration'] != null
            ? int.parse(map['duration'].toString())
            : null;

  String getDuration() {
    if (duration == null) return "0";

    return ParseUtils.minutesToTime(duration!);
  }

  String getAmount() {
    if (price == null) return "0";

    return ParseUtils.toMoney(price!);
  }
}
