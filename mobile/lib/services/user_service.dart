import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile/models/shared/response_list.dart';
import 'package:mobile/models/user/user_model.dart';
import 'package:mobile/services/request/http_request.dart';
import 'package:mobile/services/request/http_response_model.dart';
import 'package:mobile/services/service_contract.dart';

class UserService extends ServiceContract {
  UserService(BuildContext context)
      : super(HttpRequest(context, 'user'), context);

  Future<ResponseList<UserModel>> fetchAll(Map<String, String>? params) async {
    HttpResponseModel response = await httpRequest.createInstance().get();

    if (response.isError()) {
      throw Exception(response.body);
    }

    List<UserModel> result = [];

    List<dynamic> jsonList = jsonDecode(response.body)['items'];
    for (var jsonMap in jsonList) {
      result.add(UserModel.fromMap(jsonMap));
    }

    return ResponseList<UserModel>(
      items: result,
      total: jsonDecode(response.body)['total'],
    );
  }

  Future<UserModel?> getLogged() async {
    HttpResponseModel response =
        await httpRequest.createInstance().withEndpoint('me').get();

    if (response.isError()) {
      throw Exception(response.body);
    }

    return UserModel.fromMap(
      jsonDecode(response.body),
    );
  }
}
