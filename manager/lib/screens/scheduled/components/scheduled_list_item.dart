import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:manager/components/confirmation_dialog.dart';
import 'package:manager/components/template/data_label.dart';
import 'package:manager/models/enums/service_type.dart';
import 'package:manager/models/scheduled/scheduled_model.dart';
import 'package:manager/store/scheduled_store.dart';
import 'package:provider/provider.dart';

class ScheduledListItem extends StatelessWidget {
  final ScheduledModel scheduled;

  const ScheduledListItem(this.scheduled, {Key? key}) : super(key: key);

  Future<void> openConfirmMap(BuildContext context) async {
    if (await showConfirmationDialog(
      context,
      title: "Deslocamento",
      content: "Você tem certeza que deseja abrir o GPS?",
    )) {
      MapsLauncher.launchQuery(
          scheduled.addresses.startAddress.getFullAddress());
    }
  }

  void openConfirmCancel(BuildContext context, String id) {
    showConfirmationDialog(
      context,
      title: "Cancelar agendamento",
      content: "Você tem certeza que deseja cancelar?",
    ).then((isConfirmed) {
      if (!isConfirmed) {
        return;
      }

      ScheduledStore scheduledStore =
          Provider.of<ScheduledStore>(context, listen: false);

      scheduledStore.delete(context, id).then(
        (value) {
          if (value) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Agendamento cancelado!'),
              ),
            );

            scheduledStore.refetch(context);
          }
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
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
              Row(
                children: [
                  scheduled.service.type == ServiceType.external
                      ? IconButton(
                          onPressed: () => openConfirmMap(context),
                          icon: const Icon(Icons.pin_drop),
                        )
                      : Container(),
                  IconButton(
                    onPressed: () => openConfirmCancel(context, scheduled.id),
                    icon: const Icon(Icons.cancel),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
