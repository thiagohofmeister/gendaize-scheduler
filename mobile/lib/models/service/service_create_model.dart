import 'package:mobile/models/tax/tax_model.dart';
import 'package:mobile/models/user/user_model.dart';

import '../enums/service_type.dart';

class ServiceCreateModel {
  String name;
  double price;
  ServiceType type;
  int sameTimeQuantity;
  int duration;
  List<UserModel> users;
  List<TaxModel> taxes;

  ServiceCreateModel({
    required this.name,
    required this.price,
    required this.type,
    required this.sameTimeQuantity,
    required this.duration,
    required this.users,
    required this.taxes,
  });

  toMap() {
    return {
      'name': name,
      'price': price,
      'type': type.name.toUpperCase(),
      'sameTimeQuantity': sameTimeQuantity,
      'duration': duration,
      'users': users.map((user) => ({'id': user.id})).toList(),
      'taxes': taxes.map((tax) => ({'id': tax.id})).toList(),
    };
  }
}
