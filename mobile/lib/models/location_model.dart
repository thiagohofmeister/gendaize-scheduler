class LocationModel {
  String id;
  String state;
  String city;

  LocationModel({
    required this.id,
    required this.state,
    required this.city,
  });

  LocationModel.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        state = map['state'],
        city = map['city'];
}
