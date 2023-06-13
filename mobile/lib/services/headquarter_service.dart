import 'dart:convert';

import 'package:mobile/models/headquarter_create_model.dart';
import 'package:mobile/models/headquarter_model.dart';
import 'package:mobile/models/response_list.dart';
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
}
