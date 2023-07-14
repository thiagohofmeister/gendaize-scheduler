import 'package:flutter/material.dart';
import 'package:manager/components/template/data_label.dart';
import 'package:manager/models/service/service_model.dart';
import 'package:manager/models/shared/amount_model.dart';

class ServiceBudgetListItem extends StatelessWidget {
  final ServiceModel service;
  final AmountModel amount;

  const ServiceBudgetListItem({
    Key? key,
    required this.service,
    required this.amount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: SizedBox(
        width: double.infinity,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: DataLabel(
                    label: 'Serviço',
                    info: service.name,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: DataLabel(
                    label: 'Duração',
                    info: service.getDuration(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: DataLabel(
                    label: 'Valor aula',
                    info: amount.getSubtotal(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: DataLabel(
                    label: 'Taxa de deslocamento',
                    info: amount.taxes > 0 ? amount.getTaxes() : 'Grátis',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: DataLabel(
                    label: 'Total',
                    info: amount.getTotal(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
