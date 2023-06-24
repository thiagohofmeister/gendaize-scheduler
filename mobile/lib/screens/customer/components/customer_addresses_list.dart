import 'package:flutter/material.dart';
import 'package:mobile/models/customer/customer_model.dart';
import 'package:mobile/screens/customer/components/customer_address_item.dart';

class CustomerAddressesList extends StatelessWidget {
  final CustomerModel customer;
  final Function(String) refetchCustomer;

  const CustomerAddressesList({
    Key? key,
    required this.customer,
    required this.refetchCustomer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ...customer.addresses.map((address) {
        return CustomerAddressItem(
          address,
          customerId: customer.id,
          refetchCustomer: refetchCustomer,
        );
      }),
      ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(
              context,
              'customer-address-add',
              arguments: customer,
            ).then((value) => refetchCustomer(customer.id));
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add),
              SizedBox(width: 10),
              Text('Cadastrar endereço'),
            ],
          ))
    ]);
  }
}
