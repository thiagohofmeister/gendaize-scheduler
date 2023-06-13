class LocationGetAddressModel {
  String state;
  String city;
  String street;

  LocationGetAddressModel(
      {required this.state, required this.city, required this.street});

  Map<String, dynamic> toMap() {
    return {
      'uf': state,
      'city': city,
      'street': street,
    };
  }
}
