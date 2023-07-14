import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:manager/models/location/location_model.dart';
import 'package:manager/services/request/http_request.dart';
import 'package:manager/services/request/http_response_model.dart';
import 'package:manager/services/service_contract.dart';

class OrganizationService extends ServiceContract {
  OrganizationService(BuildContext context)
      : super(HttpRequest(context, 'organization'), context);

  Future<List<LocationModel>> fetchAll(Map<String, String>? params) async {
    HttpResponseModel response =
        await httpRequest.createInstance().withEndpoint('locations').get();

    if (response.isError()) {
      throw Exception(response.body);
    }

    List<LocationModel> result = [];

    List<dynamic> jsonList = jsonDecode(response.body);
    for (var jsonMap in jsonList) {
      result.add(LocationModel.fromMap(jsonMap));
    }

    return result;
  }
}
