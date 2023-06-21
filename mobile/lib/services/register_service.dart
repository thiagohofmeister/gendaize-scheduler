import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile/models/register/register_model.dart';
import 'package:mobile/services/request/http_request.dart';
import 'package:mobile/services/request/http_response_model.dart';
import 'package:mobile/services/service_contract.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterService extends ServiceContract {
  RegisterService(BuildContext context)
      : super(HttpRequest(context, 'register'), context);

  Future<void> register(RegisterModel data) async {
    HttpResponseModel response = await httpRequest
        .createInstance()
        .withPayload(jsonEncode(data.toMap()))
        .post();

    if (response.isError()) {
      throw Exception(response.body);
    }

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(
        'token', jsonDecode(response.body)['authentication']['token']);
  }
}
