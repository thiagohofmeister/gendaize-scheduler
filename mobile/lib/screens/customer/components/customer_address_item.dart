import 'package:flutter/material.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:mobile/components/confirmation_dialog.dart';
import 'package:mobile/components/template/data_label.dart';
import 'package:mobile/models/shared/address_model.dart';
import 'package:mobile/store/customer_store.dart';
import 'package:provider/provider.dart';

class CustomerAddressItem extends StatefulWidget {
  final String customerId;
  final Function(String) refetchCustomer;
  final AddressModel address;

  const CustomerAddressItem(
    this.address, {
    Key? key,
    required this.customerId,
    required this.refetchCustomer,
  }) : super(key: key);

  @override
  State<CustomerAddressItem> createState() => _CustomerAddressItemState();
}

class _CustomerAddressItemState extends State<CustomerAddressItem> {
  Future<void> openConfirmMap(BuildContext context) async {
    if (await showConfirmationDialog(
      context,
      title: "Deslocamento",
      content: "Você tem certeza que deseja abrir o GPS?",
    )) {
      MapsLauncher.launchQuery(widget.address.getFullAddress());
    }
  }

  void openConfirmDeleteAddress(BuildContext context, String id) {
    showConfirmationDialog(
      context,
      title: "Exclusão",
      content: "Você tem certeza que deseja excluir o endereço?",
    ).then((isConfirmed) {
      if (!isConfirmed) {
        return;
      }

      CustomerStore customerStore =
          Provider.of<CustomerStore>(context, listen: false);

      customerStore.deleteAddress(context, widget.customerId, id).then(
        (value) {
          if (value) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Endereço excluído!'),
              ),
            );

            widget.refetchCustomer(widget.customerId);
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
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DataLabel(label: 'CEP', info: widget.address.zipCode),
                DataLabel(
                  label: 'Cidade',
                  info: '${widget.address.city} - ${widget.address.state}',
                ),
                DataLabel(label: 'Bairro', info: widget.address.district),
                DataLabel(
                  label: 'Rua',
                  info: '${widget.address.street}, nº ${widget.address.number}',
                ),
                DataLabel(
                  label: 'Complemento',
                  info: widget.address.complement ?? '-',
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => openConfirmMap(context),
                      icon: const Icon(Icons.pin_drop),
                    ),
                    IconButton(
                      onPressed: () => openConfirmDeleteAddress(
                        context,
                        widget.address.id!,
                      ),
                      icon: const Icon(Icons.delete),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
