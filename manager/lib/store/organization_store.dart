import 'package:flutter/material.dart';
import 'package:manager/models/location/location_model.dart';
import 'package:manager/services/organization_service.dart';
import 'package:manager/store/store_contract.dart';

class OrganizationStore extends StoreContract {
  List<LocationModel> locations = [];
  List<String> states = [];
  List<String> cities = [];

  OrganizationStore() : super();

  Future<void> getAll(BuildContext context, Map<String, String>? params) async {
    locations = await OrganizationService(context).fetchAll(params);
    fillStates();
  }

  void fillStates() {
    states = locations.map((item) => item.state).toSet().toList();
  }

  List<String> getCities(String state) {
    return locations
        .where((item) => item.state == state)
        .map((item) => item.city)
        .toList();
  }
}
