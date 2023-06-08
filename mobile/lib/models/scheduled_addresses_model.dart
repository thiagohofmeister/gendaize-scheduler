import 'package:mobile/models/address_model.dart';

class ScheduledAddressesModel {
  AddressModel originAddress;
  AddressModel startAddress;
  AddressModel? endAddress;

  ScheduledAddressesModel({
    required this.originAddress,
    required this.startAddress,
    this.endAddress,
  });

  ScheduledAddressesModel.fromMap(Map<String, dynamic> map)
      : originAddress = AddressModel.fromMap(map['originAddress']),
        startAddress = AddressModel.fromMap(map['startAddress']),
        endAddress = map['endAddress'] != null
            ? AddressModel.fromMap(map['endAddress'])
            : null;
}
