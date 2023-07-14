import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:manager/models/location/location_get_address_model.dart';
import 'package:manager/models/location/location_model.dart';
import 'package:manager/models/location/zipcode_model.dart';
import 'package:manager/models/shared/response_list.dart';
import 'package:manager/services/request/http_request.dart';
import 'package:manager/services/request/http_response_model.dart';
import 'package:manager/services/service_contract.dart';

class LocationService extends ServiceContract {
  LocationService(BuildContext context)
      : super(HttpRequest(context, 'location'), context);

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
