import 'package:flutter/material.dart';
import 'package:mobile/components/template/data_label.dart';
import 'package:mobile/models/customer/customer_model.dart';

class CustomerData extends StatelessWidget {
  const CustomerData({super.key, required this.customer});

  final CustomerModel customer;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: DataLabel(label: 'Nome', info: customer.name),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: DataLabel(label: 'Telefone', info: customer.phone),
        ),
      ],
    );
  }
}
