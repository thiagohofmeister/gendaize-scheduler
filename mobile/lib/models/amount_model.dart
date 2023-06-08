import 'package:mobile/utils/parse_utils.dart';

class AmountModel {
  double subtotal;
  double discount;
  double taxes;
  double total;

  AmountModel({
    required this.subtotal,
    required this.discount,
    required this.taxes,
    required this.total,
  });

  AmountModel.fromMap(Map<String, dynamic> map)
      : subtotal = double.parse(map['subtotal'].toString()),
        discount = double.parse(map['discount'].toString()),
        taxes = double.parse(map['taxes'].toString()),
        total = double.parse(map['total'].toString());

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
