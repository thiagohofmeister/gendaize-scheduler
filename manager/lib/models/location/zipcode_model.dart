class ZipcodeModel {
  String zipCode;
  String street;
  String state;
  String district;

  ZipcodeModel({
    required this.zipCode,
    required this.street,
    required this.state,
    required this.district,
  });

  ZipcodeModel.fromMap(Map<String, dynamic> json)
      : zipCode = json['zipCode'],
        street = json['street'],
        state = json['state'],
        district = json['district'];

  Map<String, dynamic> toMap() {
    return {
      'zipCode': zipCode,
      'street': street,
      'state': state,
      'district': district
    };
  }

  static List<ZipcodeModel> fromMapList(List<dynamic> list) {
    return list.map((item) => ZipcodeModel.fromMap(item)).toList();
  }
}
