import 'package:flutter/material.dart';
import 'package:manager/components/template/data_label.dart';
import 'package:manager/models/location/location_model.dart';

class HeadquarterListItem extends StatelessWidget {
  final LocationModel location;

  const HeadquarterListItem({Key? key, required this.location})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
              child: DataLabel(
                label: 'Estado',
                info: location.state,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
              child: DataLabel(
                label: 'Cidade',
                info: location.city,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
