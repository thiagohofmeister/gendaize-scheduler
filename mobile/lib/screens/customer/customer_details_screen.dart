import 'package:flutter/material.dart';
import 'package:mobile/components/confirmation_dialog.dart';
import 'package:mobile/components/template/data_label.dart';
import 'package:mobile/models/customer/customer_model.dart';
import 'package:mobile/store/customer_store.dart';
import 'package:mobile/utils/parse_utils.dart';
import 'package:provider/provider.dart';

class CustomerDetailsScreen extends StatefulWidget {
  const CustomerDetailsScreen({Key? key}) : super(key: key);

  @override
  State<CustomerDetailsScreen> createState() => _CustomerDetailsScreenState();
}

class _CustomerDetailsScreenState extends State<CustomerDetailsScreen> {
  CustomerModel? customer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final CustomerModel? customerFromArgs =
        ModalRoute.of(context)?.settings.arguments as CustomerModel?;

    if (customerFromArgs != null) {
      customer = Provider.of<CustomerStore>(context, listen: false)
          .items
          .firstWhere((i) => i.id == customerFromArgs.id);
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

      customerStore.deleteAddress(context, customer!.id, id).then(
        (value) {
          if (value) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Endereço excluído!'),
              ),
            );

            customerStore.refetch(context).then((value) {
              setState(() {
                customer =
                    customerStore.items.firstWhere((i) => i.id == customer!.id);
              });
            });
          }
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    CustomerStore customerStore =
        Provider.of<CustomerStore>(context, listen: true);

    return Scaffold(
      appBar: AppBar(title: Text(customer!.name)),
      body: SingleChildScrollView(
        child: customerStore.isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DataLabel(
                        label: 'Telefone',
                        info: ParseUtils.toPhone(customer!.phone)),
                    customer!.email != null
                        ? DataLabel(label: 'Email', info: customer!.email!)
                        : Container(),
                    const SizedBox(height: 20),
                    const Text(
                      'Endereços:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    ...customer!.addresses.map((address) {
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
                                  DataLabel(
                                      label: 'CEP', info: address.zipCode),
                                  DataLabel(
                                    label: 'Cidade',
                                    info: '${address.city} - ${address.state}',
                                  ),
                                  DataLabel(
                                      label: 'Bairro', info: address.district),
                                  DataLabel(
                                    label: 'Rua',
                                    info:
                                        '${address.street}, nº ${address.number}',
                                  ),
                                  DataLabel(
                                    label: 'Complemento',
                                    info: address.complement ?? '-',
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () =>
                                            openConfirmDeleteAddress(
                                          context,
                                          address.id!,
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
                    }).toList()
                  ],
                ),
              ),
      ),
    );
  }
}
