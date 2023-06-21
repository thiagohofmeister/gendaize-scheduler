import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile/models/scheduled/scheduled_create_calculate_amount_model.dart';
import 'package:mobile/models/scheduled/scheduled_create_model.dart';
import 'package:mobile/models/scheduled/scheduled_model.dart';
import 'package:mobile/models/shared/amount_model.dart';
import 'package:mobile/models/shared/response_list.dart';
import 'package:mobile/services/request/http_request.dart';
import 'package:mobile/services/request/http_response_model.dart';
import 'package:mobile/services/service_contract.dart';

class ScheduledService extends ServiceContract {
  ScheduledService(BuildContext context)
      : super(HttpRequest(context, 'scheduled'), context);

  Future<ResponseList> fetchAll(Map<String, String>? params) async {
    HttpResponseModel response =
        await httpRequest.createInstance().withParams(params).get();

    if (response.isError()) {
      throw Exception(response.body);
    }

    List<ScheduledModel> result = [];

    List<dynamic> jsonList = jsonDecode(response.body)['items'];
    for (var jsonMap in jsonList) {
      result.add(ScheduledModel.fromMap(jsonMap));
    }

    return ResponseList<ScheduledModel>(
      items: result,
      total: jsonDecode(response.body)['total'],
    );
  }

  Future<bool> delete(String id) async {
    HttpResponseModel response =
        await httpRequest.createInstance().withEndpoint(id).delete();

    if (response.isError()) {
      throw Exception(response.body);
    }

    return true;
  }

  Future<List<AmountModel>> createCalculatePrice(
      ScheduledCreateCalculateAmountModel data) async {
    HttpResponseModel response = await httpRequest
        .createInstance()
        .withPayload(jsonEncode(data.toMap()))
        .withEndpoint('calculate-amount')
        .post();

    if (response.isError()) {
      throw Exception(response.body);
    }

    return AmountModel.fromList(jsonDecode(response.body));
  }

  Future<ScheduledModel> create(ScheduledCreateModel data) async {
    HttpResponseModel response = await httpRequest
        .createInstance()
        .withPayload(jsonEncode(data.toMap()))
        .post();

    if (response.isError()) {
      throw Exception(response.body);
    }

    return ScheduledModel.fromMap(jsonDecode(response.body));
  }
}
