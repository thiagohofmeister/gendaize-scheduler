import 'dart:convert';

import 'package:mobile/models/amount_model.dart';
import 'package:mobile/models/response_list.dart';
import 'package:mobile/models/scheduled_create_calculate_amount_model.dart';
import 'package:mobile/models/scheduled_model.dart';
import 'package:mobile/services/request/http_request.dart';
import 'package:mobile/services/request/http_response_model.dart';
import 'package:mobile/services/service_contract.dart';

class ScheduledService extends ServiceContract {
  ScheduledService() : super(HttpRequest('scheduled'));

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
    HttpResponseModel response = await httpRequest.createInstance().delete();

    if (response.isError()) {
      throw Exception(response.body);
    }

    return true;
  }

  Future<AmountModel> createCalculatePrice(
      ScheduledCreateCalculateAmountModel data) async {
    HttpResponseModel response = await httpRequest
        .createInstance()
        .withPayload(jsonEncode(data.toMap()))
        .post();

    if (response.isError()) {
      throw Exception(response.body);
    }

    return AmountModel.fromMap(jsonDecode(response.body));
  }
}
