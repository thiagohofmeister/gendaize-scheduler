import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:manager/models/service/service_create_model.dart';
import 'package:manager/models/service/service_model.dart';
import 'package:manager/models/shared/response_list.dart';
import 'package:manager/services/request/http_request.dart';
import 'package:manager/services/request/http_response_model.dart';
import 'package:manager/services/service_contract.dart';

class ServiceService extends ServiceContract {
  ServiceService(BuildContext context)
      : super(HttpRequest(context, 'service'), context);

  Future<ResponseList<ServiceModel>> fetchAll(
      Map<String, String>? params) async {
    HttpResponseModel response = await httpRequest.createInstance().get();

    if (response.isError()) {
      throw Exception(response.body);
    }

    List<ServiceModel> result = [];

    List<dynamic> jsonList = jsonDecode(response.body)['items'];
    for (var jsonMap in jsonList) {
      result.add(ServiceModel.fromMap(jsonMap));
    }

    return ResponseList<ServiceModel>(
      items: result,
      total: jsonDecode(response.body)['total'],
    );
  }

  Future<ServiceModel> create(ServiceCreateModel data) async {
    HttpResponseModel response = await httpRequest
        .createInstance()
        .withPayload(jsonEncode(data.toMap()))
        .post();

    if (response.isError()) {
      throw Exception(response.body);
    }

    return ServiceModel.fromMap(jsonDecode(response.body));
  }
}
