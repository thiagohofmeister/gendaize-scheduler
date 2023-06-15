import 'dart:convert';

import 'package:mobile/models/location/location_get_address_model.dart';
import 'package:mobile/models/location/location_model.dart';
import 'package:mobile/models/location/zipcode_model.dart';
import 'package:mobile/models/shared/response_list.dart';
import 'package:mobile/services/request/http_request.dart';
import 'package:mobile/services/request/http_response_model.dart';
import 'package:mobile/services/service_contract.dart';

class LocationService extends ServiceContract {
  LocationService() : super(HttpRequest('location'));

  Future<List<ZipcodeModel>> getZipcodeByAddress(
      LocationGetAddressModel data) async {
    HttpResponseModel response = await httpRequest
        .createInstance()
        .withEndpoint('address')
        .withPayload(jsonEncode(data.toMap()))
        .post();

    if (response.isError()) {
      throw Exception(response.body);
    }

    return ZipcodeModel.fromMapList(jsonDecode(response.body));
  }

  Future<ResponseList<LocationModel>> fetchAll(
      Map<String, String>? params) async {
    HttpResponseModel response =
        await httpRequest.createInstance().withParams(params).get();

    if (response.isError()) {
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
