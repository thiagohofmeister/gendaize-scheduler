import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobile/models/response_list.dart';
import 'package:mobile/models/scheduled_model.dart';
import 'package:mobile/services/service_contract.dart';

class ScheduledService extends ServiceContract {
  static const String resource = 'scheduled';

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
}
