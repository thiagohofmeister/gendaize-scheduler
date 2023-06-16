import 'dart:convert';

import 'package:mobile/models/customer/customer_create_model.dart';
import 'package:mobile/models/customer/customer_model.dart';
import 'package:mobile/models/shared/response_list.dart';
import 'package:mobile/services/request/http_request.dart';
import 'package:mobile/services/request/http_response_model.dart';
import 'package:mobile/services/service_contract.dart';

class CustomerService extends ServiceContract {
  CustomerService() : super(HttpRequest('customer'));

  Future<ResponseList<CustomerModel>> fetchAll(
      Map<String, String>? params) async {
    HttpResponseModel response = await httpRequest.createInstance().get();

    if (response.isError()) {
      throw Exception(response.body);
    }

    List<CustomerModel> result = [];

    List<dynamic> jsonList = jsonDecode(response.body)['items'];
    for (var jsonMap in jsonList) {
      result.add(CustomerModel.fromMap(jsonMap));
    }

    return ResponseList<CustomerModel>(
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

  Future<CustomerModel> create(CustomerCreateModel data) async {
    HttpResponseModel response = await httpRequest
        .createInstance()
        .withPayload(jsonEncode(data.toMap()))
        .post();

    if (response.isError()) {
      throw Exception(response.body);
    }

    return CustomerModel.fromMap(jsonDecode(response.body));
  }
}
