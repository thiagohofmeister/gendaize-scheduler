import 'package:flutter/material.dart';
import 'package:mobile/components/customer_data.dart';
import 'package:mobile/models/customer/customer_model.dart';

class CustomerItem extends StatelessWidget {
  final CustomerModel customer;

  const CustomerItem({Key? key, required this.customer}) : super(key: key);

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
                          .pushNamed('schedule', arguments: customer);
                    },
                    icon: const Icon(Icons.timer_sharp),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed('budget', arguments: customer);
                    },
                    icon: const Icon(Icons.monetization_on),
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
