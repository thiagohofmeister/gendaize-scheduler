import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobile/models/customer_model.dart';
import 'package:mobile/models/response_list.dart';
import 'package:mobile/services/service_contract.dart';

class CustomerService extends ServiceContract {
  static const String resource = 'customer';

  Future<ResponseList> fetchAll(Map<String, String>? params) async {
    http.Response response = await httpClient.get(
      getUri(
        resource: resource,
      ),
      headers: {...(await defaultHeaders())},
    );

    if (isError(response)) {
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
    http.Response response = await httpClient.delete(
      getUri(resource: resource, endpoint: id),
      headers: {...(await defaultHeaders())},
    );

    if (isError(response)) {
      throw Exception(response.body);
    }

    return true;
  }
}
