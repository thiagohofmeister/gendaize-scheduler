class AddressModel {
  String? id;
  String zipCode;
  String state;
  String city;
  String district;
  String street;
  String number;
  String? complement;

  AddressModel({
    this.id,
    required this.zipCode,
    required this.state,
    required this.city,
    required this.district,
    required this.street,
    required this.number,
    this.complement,
  });

  AddressModel.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        zipCode = map['zipCode'],
        state = map['state'],
        city = map['city'],
        district = map['district'],
        street = map['street'],
        number = map['number'],
        complement = map['complement'];

  static List<AddressModel> fromList(List<dynamic> list) {
    return list.map((item) => AddressModel.fromMap(item)).toList();
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'zipCode': zipCode,
      'state': state,
      'city': city,
      'district': district,
      'street': street,
      'number': number,
      'complement': complement,
    };

    if (id != null) {
      map['id'] = id;
    }

    return map;
  }

  String getFullAddress() {
    String comp =
        complement != null && complement!.isNotEmpty ? ' - $complement' : '';
    return '$street, $number$comp - $city, $zipCode';
  }
}
