import 'package:mobile/models/amount_model.dart';
import 'package:mobile/models/customer_model.dart';
import 'package:mobile/models/headquarter_model.dart';
import 'package:mobile/models/scheduled_addresses_model.dart';
import 'package:mobile/models/service_model.dart';
import 'package:mobile/models/user_model.dart';
import 'package:mobile/utils/parse_utils.dart';

class ScheduledModel {
  String id;
  DateTime startAt;
  DateTime endAt;
  DateTime createdAt;
  String status;
  ScheduledAddressesModel addresses;
  AmountModel amount;
  UserModel user;
  CustomerModel customer;
  ServiceModel service;
  HeadquarterModel headquarter;

  ScheduledModel({
    required this.id,
    required this.startAt,
    required this.endAt,
    required this.createdAt,
    required this.status,
    required this.addresses,
    required this.amount,
    required this.user,
    required this.customer,
    required this.service,
    required this.headquarter,
  });

  ScheduledModel.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        startAt = DateTime.parse(map['startAt']),
        endAt = DateTime.parse(map['endAt']),
        createdAt = DateTime.parse(map['createdAt']),
        status = map['status'],
        addresses = ScheduledAddressesModel.fromMap(map['addresses']),
        amount = AmountModel.fromMap(map['amount']),
        user = UserModel.fromMap(map['user']),
        customer = CustomerModel.fromMap(map['customer']),
        service = ServiceModel.fromMap(map['service']),
        headquarter = HeadquarterModel.fromMap(map['headquarter']);

  String getStartAt() {
    return ParseUtils.toStringDate(startAt);
  }

  String getEndAt() {
    return ParseUtils.toStringDate(endAt);
  }
}
