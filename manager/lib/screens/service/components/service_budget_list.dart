import 'package:flutter/material.dart';
import 'package:manager/models/service/service_model.dart';
import 'package:manager/models/shared/amount_model.dart';
import 'package:manager/screens/service/components/service_budget_list_item.dart';

class ServiceBudgetList extends StatelessWidget {
  final List<ServiceModel>? services;
  final List<AmountModel>? amounts;

  const ServiceBudgetList({
    Key? key,
    required this.services,
    required this.amounts,
  }) : super(key: key);

  ServiceModel getService(AmountModel amount) {
    return services!.firstWhere((service) => service.id == amount.service!.id);
  }

  @override
  Widget build(BuildContext context) {
    return services != null &&
            services!.isNotEmpty &&
            amounts != null &&
            amounts!.isNotEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 16, bottom: 16.0),
                child: Text(
                  'Valores',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              ...amounts!
                  .map((amount) => ServiceBudgetListItem(
                        service: getService(amount),
                        amount: amount,
                      ))
                  .toList(),
            ],
          )
        : Container();
  }
}
