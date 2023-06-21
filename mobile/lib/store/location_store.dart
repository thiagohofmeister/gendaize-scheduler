import 'package:flutter/material.dart';
import 'package:mobile/models/location/location_model.dart';
import 'package:mobile/models/shared/response_list.dart';
import 'package:mobile/services/location_service.dart';
import 'package:mobile/store/list_store_contract.dart';

class LocationStore extends ListStoreContract<LocationModel> {
  LocationStore() : super();
  List<String> states = [];
  List<String> cities = [];

  @override
  Future<ResponseList<LocationModel>> getAll(BuildContext context,
      {Map<String, String>? params}) {
    return LocationService(context).fetchAll(params);
  }

  @override
  Future<void> afterFetchAll() async {
    fillStates();
  }

  void fillStates() {
    states = items.map((item) => item.state).toSet().toList();
  }

  List<String> getCities(String state) {
    return items
        .where((item) => item.state == state)
        .map((item) => item.city)
        .toList();
  }
}
