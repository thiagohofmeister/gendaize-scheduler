import 'package:flutter/material.dart';
import 'package:mobile/components/confirmation_dialog.dart';
import 'package:mobile/models/customer/customer_model.dart';
import 'package:mobile/screens/customer/components/customer_data.dart';
import 'package:mobile/store/customer_store.dart';
import 'package:mobile/store/navigation_store.dart';
import 'package:provider/provider.dart';

class CustomerListItem extends StatelessWidget {
  final CustomerModel customer;

  const CustomerListItem({Key? key, required this.customer}) : super(key: key);

  void openConfirmDelete(BuildContext context, String id) {
    showConfirmationDialog(
      context,
      title: "Exclusão",
      content: "Você tem certeza que deseja excluir o cliente?",
    ).then((isConfirmed) {
      if (!isConfirmed) {
        return;
      }

      CustomerStore customerStore =
          Provider.of<CustomerStore>(context, listen: false);

      customerStore.delete(id).then(
        (value) {
          if (value) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Cliente excluído!'),
              ),
            );

            customerStore.refetch();
          }
        },
      );
    });
  }

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
              child: CustomerData(customer: customer),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed('scheduled-add', arguments: customer)
                          .then((value) {
                        if (value != null) {
                          Provider.of<NavigationStore>(
                            context,
                            listen: false,
                          ).setNameScreen('scheduled-list');
                        }
                      });
                    },
                    icon: const Icon(Icons.timer_sharp),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed('service-budget', arguments: customer);
                    },
                    icon: const Icon(Icons.paid),
                  ),
                  IconButton(
                    onPressed: () => openConfirmDelete(context, customer.id),
                    icon: const Icon(Icons.delete),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
