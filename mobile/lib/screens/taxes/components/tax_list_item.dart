import 'package:flutter/material.dart';
import 'package:mobile/components/template/data_label.dart';
import 'package:mobile/models/headquarter/headquarter_model.dart';

class TaxListItem extends StatelessWidget {
  final HeadquarterModel headquarter;

  const TaxListItem({Key? key, required this.headquarter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
              child: DataLabel(
                label: 'Nome',
                info: headquarter.name,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
              child: DataLabel(
                label: 'Endereço',
                info: headquarter.address.getFullAddress(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
