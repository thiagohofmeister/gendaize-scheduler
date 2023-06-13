import 'package:mobile/models/service/service_model.dart';
import 'package:mobile/utils/parse_utils.dart';

class AmountModel {
  double subtotal;
  double discount;
  double taxes;
  double total;
  ServiceModel? service;

  AmountModel({
    required this.subtotal,
    required this.discount,
    required this.taxes,
    required this.total,
    this.service,
  });

  AmountModel.fromMap(Map<String, dynamic> map)
      : subtotal = double.parse(map['subtotal'].toString()),
        discount = double.parse(map['discount'].toString()),
        taxes = double.parse(map['taxes'].toString()),
        total = double.parse(map['total'].toString()),
        service = map['service'] != null
            ? ServiceModel.fromMap(map['service'])
            : null;

  static List<AmountModel> fromList(List<dynamic> list) {
    return list.map((item) => AmountModel.fromMap(item)).toList();
  }

  String getSubtotal() {
    return ParseUtils.toMoney(subtotal);
  }

  String getDiscount() {
    return ParseUtils.toMoney(discount);
  }

  String getTaxes() {
    return ParseUtils.toMoney(taxes);
  }

  String getTotal() {
    return ParseUtils.toMoney(total);
  }
}
