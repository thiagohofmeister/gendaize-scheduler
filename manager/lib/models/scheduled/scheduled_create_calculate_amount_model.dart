class ScheduledCreateCalculateAmountModel {
  String customerAddressesIdStart;
  String customerId;
  String headquarterId;
  List<String> services;

  ScheduledCreateCalculateAmountModel({
    required this.customerAddressesIdStart,
    required this.customerId,
    required this.headquarterId,
    required this.services,
  });

  Map<String, dynamic> toMap() {
    return {
      'customerAddressesId': {
        'start': customerAddressesIdStart,
      },
      'customerId': customerId,
      'headquarterId': headquarterId,
      'services': services.map((service) => ({'id': service})).toList(),
    };
  }
}
