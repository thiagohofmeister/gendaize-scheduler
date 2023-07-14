import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:manager/models/shared/response_list.dart';
import 'package:manager/models/tax/tax_create_model.dart';
import 'package:manager/models/tax/tax_model.dart';
import 'package:manager/services/request/http_request.dart';
import 'package:manager/services/request/http_response_model.dart';
import 'package:manager/services/service_contract.dart';

class TaxService extends ServiceContract {
  TaxService(BuildContext context)
      : super(HttpRequest(context, 'tax'), context);

  Future<ResponseList<TaxModel>> fetchAll(Map<String, String>? params) async {
    HttpResponseModel response = await httpRequest.createInstance().get();

    if (response.isError()) {
      throw Exception(response.body);
    }

    List<TaxModel> result = [];

    List<dynamic> jsonList = jsonDecode(response.body)['items'];
    for (var jsonMap in jsonList) {
      result.add(TaxModel.fromMap(jsonMap));
    }

    return ResponseList<TaxModel>(
      items: result,
      total: jsonDecode(response.body)['total'],
    );
  }

  Future<TaxModel> create(TaxCreateModel data) async {
    HttpResponseModel response = await httpRequest
        .createInstance()
        .withPayload(jsonEncode(data.toMap()))
        .post();

    if (response.isError()) {
      throw Exception(response.body);
    }

    return TaxModel.fromMap(jsonDecode(response.body));
  }
}
