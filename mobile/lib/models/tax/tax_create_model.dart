import 'package:mobile/models/enums/tax_type.dart';
import 'package:mobile/models/enums/tax_value_type.dart';
import 'package:mobile/utils/parse_utils.dart';

class TaxCreateModel {
  String label;
  TaxType type;
  TaxValueType valueType;
  String value;
  String? valueDetails;

  TaxCreateModel({
    required this.label,
    required this.type,
    required this.valueType,
    required this.value,
    this.valueDetails,
  });

  TaxCreateModel.fromMap(Map<String, dynamic> map)
      : label = map['label'],
        type = map['type'],
        valueType = map['valueType'],
        value = map['value'],
        valueDetails = map['valueDetails'];

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'label': label,
      'type': type.name.toUpperCase(),
      'valueType': valueType.name.toUpperCase(),
      'value': valueType == TaxValueType.percent
          ? value.replaceAll('%', '')
          : ParseUtils.fromMoneyToDouble(value),
    };

    if (valueType == TaxValueType.distance) {
      map['valueDetails'] = valueDetails;
    }

    return map;
  }
}
