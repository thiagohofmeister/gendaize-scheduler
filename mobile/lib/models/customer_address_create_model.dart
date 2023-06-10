class CustomerAddressCreateModel {
  String zipCode;
  String number;
  String? complement;

  CustomerAddressCreateModel({
    required this.zipCode,
    required this.number,
    this.complement,
  });

  Map<String, dynamic> toMap() {
    return {
      'zipCode': zipCode,
      'number': number,
      'complement': complement,
    };
  }
}
