class ScheduledCreateModel {
  DateTime startAt;
  String customerAddressesIdStart;
  String? customerAddressesIdEnd;
  String customerId;
  String headquarterId;
  String serviceId;
  String userId;

  ScheduledCreateModel({
    required this.startAt,
    required this.customerAddressesIdStart,
    this.customerAddressesIdEnd,
    required this.customerId,
    required this.headquarterId,
    required this.serviceId,
    required this.userId,
  });

  Map<String, dynamic> toMap() {
    return {
      'customerAddressesId': {
        'start': customerAddressesIdStart,
      },
      'customerId': customerId,
      'headquarterId': headquarterId,
      'serviceId': serviceId,
      'startAt': startAt.toIso8601String(),
      'userId': userId
    };
  }
}
