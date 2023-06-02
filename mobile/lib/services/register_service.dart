import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobile/models/register_model.dart';
import 'package:mobile/services/service_contract.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterService extends ServiceContract {
  RegisterService() : super();

  static const String resource = 'register';

  Future<void> register(RegisterModel data) async {
    http.Response response = await super.httpClient.post(
        getUri(resource: resource),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data.toMap()));

    if (isError(response)) {
      throw Exception(response.body);
    }

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(
        'token', jsonDecode(response.body)['authentication']['token']);
  }
}
