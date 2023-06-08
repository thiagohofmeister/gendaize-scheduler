import 'package:flutter/material.dart';
import 'package:mobile/components/template/data_label.dart';
import 'package:mobile/models/enums/service_type.dart';
import 'package:mobile/models/scheduled_model.dart';

class ScheduledItem extends StatelessWidget {
  final ScheduledModel scheduled;

  const ScheduledItem({Key? key, required this.scheduled}) : super(key: key);

  Future<void> openMap() async {
    // MapsLauncher.launchQuery(schedule.student.address.getFullAddress());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: DataLabel(
                  label: 'Cliente',
                  info: scheduled.customer.name,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: DataLabel(
                  label: 'Início',
                  info: scheduled.getStartAt(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: DataLabel(
                  label: 'Final',
                  info: scheduled.getEndAt(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: DataLabel(
                  label: 'Duração',
                  info: scheduled.service.getDuration(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: DataLabel(
                  label: 'Endereço',
                  info: scheduled.addresses.startAddress.getFullAddress(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: DataLabel(
                  label: 'Preço',
                  info: scheduled.amount.getTotal(),
                ),
              ),
              scheduled.service.type == ServiceType.external
                  ? ElevatedButton(
                      onPressed: openMap,
                      child: const Text('Ir até o cliente'),
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }
}
