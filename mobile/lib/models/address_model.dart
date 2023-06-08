class AddressModel {
  String zipCode;
  String state;
  String city;
  String district;
  String street;
  String number;
  String? complement;

  AddressModel({
    required this.zipCode,
    required this.state,
    required this.city,
    required this.district,
    required this.street,
    required this.number,
    this.complement,
  });

  AddressModel.fromMap(Map<String, dynamic> map)
      : zipCode = map['zipCode'],
        state = map['state'],
        city = map['city'],
        district = map['district'],
        street = map['street'],
        number = map['number'],
        complement = map['complement'];

  static List<AddressModel> fromList(List<dynamic> list) {
    return list.map((item) => AddressModel.fromMap(item)).toList();
  }

  String getFullAddress() {
    String comp =
        complement != null && complement!.isNotEmpty ? ' - $complement' : '';
    return '$street, $number$comp - $city, $zipCode';
  }
}
