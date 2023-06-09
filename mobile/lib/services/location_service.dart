import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobile/models/location_get_address_model.dart';
import 'package:mobile/models/location_model.dart';
import 'package:mobile/models/response_list.dart';
import 'package:mobile/models/zipcode_model.dart';
import 'package:mobile/services/service_contract.dart';

class LocationService extends ServiceContract {
  LocationService() : super();

  static const String resource = 'location';

  Future<List<ZipcodeModel>> getZipcodeByAddress(
      LocationGetAddressModel data) async {
    http.Response response = await httpClient.get(
      getUri(
        resource: resource,
      ),
      headers: {...(await defaultHeaders())},
    );

    if (isError(response)) {
      throw Exception(response.body);
    }

    return ZipcodeModel.fromMapList(jsonDecode(response.body));
  }

  Future<ResponseList> fetchAll(Map<String, String>? params) async {
    http.Response response = await httpClient.get(
      getUri(
        resource: resource,
      ),
      headers: {...(await defaultHeaders())},
    );

    if (isError(response)) {
      throw Exception(response.body);
    }

    List<LocationModel> result = [];

    List<dynamic> jsonList = jsonDecode(response.body)['items'];
    for (var jsonMap in jsonList) {
      result.add(LocationModel.fromMap(jsonMap));
    }

    return ResponseList<LocationModel>(
      items: result,
      total: jsonDecode(response.body)['total'],
    );
  }
}
