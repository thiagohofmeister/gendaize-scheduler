import 'package:flutter/material.dart';
import 'package:mobile/components/template/data_label.dart';
import 'package:mobile/models/enums/tax_type.dart';
import 'package:mobile/models/enums/tax_value_type.dart';
import 'package:mobile/models/tax/tax_model.dart';
import 'package:mobile/utils/parse_utils.dart';

class TaxListItem extends StatelessWidget {
  final TaxModel tax;

  const TaxListItem({Key? key, required this.tax}) : super(key: key);

  String getValue() {
    if (tax.valueType == TaxValueType.percent) {
      return '${tax.value.toString()}%';
    }

    if (tax.valueType == TaxValueType.distance && tax.valueDetails != null) {
      return '${ParseUtils.toMoney(tax.value)} a cada ${ParseUtils.toStringDistance(tax.valueDetails!)}';
    }

    return ParseUtils.toMoney(tax.value);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: DataLabel(
                  label: 'Nome',
                  info: tax.label,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: DataLabel(
                  label: 'Tipo',
                  info: tax.type.getLabel(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: DataLabel(
                  label: 'Tipo de valor',
                  info: tax.valueType.getLabel(),
                ),
              ),
              DataLabel(
                label: 'Valor',
                info: getValue(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
