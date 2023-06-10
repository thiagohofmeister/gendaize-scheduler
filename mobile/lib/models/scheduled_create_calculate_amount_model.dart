class ScheduledCreateCalculateAmountModel {
  String customerAddressesIdStart;
  String customerId;
  String headquarterId;
  String serviceId;

  ScheduledCreateCalculateAmountModel({
    required this.customerAddressesIdStart,
    required this.customerId,
    required this.headquarterId,
    required this.serviceId,
  });

  Map<String, dynamic> toMap() {
    return {
      'customerAddressesId': {
        'start': customerAddressesIdStart,
      },
      'customerId': customerId,
      'headquarterId': headquarterId,
      'serviceId': serviceId
    };
  }
}
