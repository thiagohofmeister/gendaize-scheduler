import 'dart:convert';

import 'package:mobile/models/response_list.dart';
import 'package:mobile/models/service_model.dart';
import 'package:mobile/services/request/http_request.dart';
import 'package:mobile/services/request/http_response_model.dart';
import 'package:mobile/services/service_contract.dart';

class ServiceService extends ServiceContract {
  ServiceService() : super(HttpRequest('service'));

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
}
