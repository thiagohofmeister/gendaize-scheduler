import 'package:flutter/material.dart';
import 'package:manager/components/template/data_label.dart';
import 'package:manager/models/service/service_model.dart';

class ServiceListItem extends StatelessWidget {
  final ServiceModel service;

  const ServiceListItem(this.service, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
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
                  info: service.name,
                ),
              ),
              DataLabel(
                label: 'Preço',
                info: service.getAmount(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
