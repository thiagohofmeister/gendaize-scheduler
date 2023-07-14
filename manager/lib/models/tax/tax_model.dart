import 'package:manager/models/enums/tax_type.dart';
import 'package:manager/models/enums/tax_value_type.dart';

class TaxModel {
  String? id;
  String label;
  TaxType type;
  TaxValueType valueType;
  double value;
  int? valueDetails;

  TaxModel({
    this.id,
    required this.label,
    required this.type,
    required this.valueType,
    required this.value,
    this.valueDetails,
  });

  TaxModel.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        label = map['label'],
        type = TaxTypeExtension.fromString(map['type']),
        valueType = TaxValueTypeExtension.fromString(map['valueType']),
        value = double.parse(map['value'].toString()),
        valueDetails = map['valueDetails'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'label': label,
      'type': type,
      'valueType': valueType,
      'value': value,
      'valueDetails': valueDetails,
    };
  }
}
