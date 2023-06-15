import 'dart:convert';

import 'package:mobile/models/headquarter/headquarter_create_model.dart';
import 'package:mobile/models/headquarter/headquarter_model.dart';
import 'package:mobile/models/location/location_model.dart';
import 'package:mobile/models/shared/response_list.dart';
import 'package:mobile/services/request/http_request.dart';
import 'package:mobile/services/request/http_response_model.dart';
import 'package:mobile/services/service_contract.dart';

class HeadquarterService extends ServiceContract {
  HeadquarterService() : super(HttpRequest('headquarter'));

  Future<ResponseList<HeadquarterModel>> fetchAll(
      Map<String, String>? params) async {
    HttpResponseModel response = await httpRequest.createInstance().get();

    if (response.isError()) {
      throw Exception(response.body);
    }

    List<HeadquarterModel> result = [];

    List<dynamic> jsonList = jsonDecode(response.body)['items'];
    for (var jsonMap in jsonList) {
      result.add(HeadquarterModel.fromMap(jsonMap));
    }

    return ResponseList<HeadquarterModel>(
      items: result,
      total: jsonDecode(response.body)['total'],
    );
  }

  Future<HeadquarterModel> create(HeadquarterCreateModel data) async {
    HttpResponseModel response = await httpRequest
        .createInstance()
        .withPayload(jsonEncode(data.toMap()))
        .post();

    if (response.isError()) {
      throw Exception(response.body);
    }

    return HeadquarterModel.fromMap(jsonDecode(response.body));
  }

  Future<HeadquarterModel> fetchById(String headquarterId) async {
    HttpResponseModel response =
        await httpRequest.createInstance().withEndpoint(headquarterId).get();

    if (response.isError()) {
      throw Exception(response.body);
    }

    return HeadquarterModel.fromMap(jsonDecode(response.body));
  }

  Future<HeadquarterModel> updateLocations(
      String headquarterId, List<LocationModel> data) async {
    String payload = jsonEncode(data.map((location) {
      return {
        'id': location.id,
      };
    }).toList());

    print(payload);

    HttpResponseModel response = await httpRequest
        .createInstance()
        .withEndpoint('$headquarterId/locations')
        .withPayload(payload)
        .put();

    if (response.isError()) {
      throw Exception(response.body);
    }

    return HeadquarterModel.fromMap(jsonDecode(response.body));
  }
}
