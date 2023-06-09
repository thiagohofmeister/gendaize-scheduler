class CustomerAddressCreateModel {
  String zipCode;
  String number;
  String? complement;

  CustomerAddressCreateModel({
    required this.zipCode,
    required this.number,
    this.complement,
  });
}
