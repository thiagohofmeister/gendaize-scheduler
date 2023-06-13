import 'dart:convert';

import 'package:mobile/models/authentication/authentication_model.dart';
import 'package:mobile/services/request/http_request.dart';
import 'package:mobile/services/request/http_response_model.dart';
import 'package:mobile/services/service_contract.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationService extends ServiceContract {
  AuthenticationService() : super(HttpRequest('authentication'));

  Future<AuthenticationModel> authenticate(String user, String password) async {
    String basicAuth = base64Encode(utf8.encode('$user:$password'));

    HttpResponseModel response = await httpRequest
        .createInstance(isLogged: false)
        .addHeader('authorization', 'Basic $basicAuth')
        .post();

    if (response.isError()) {
      throw Exception(response.body);
    }

    AuthenticationModel auth = AuthenticationModel.fromJson(
      jsonDecode(response.body),
    );

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("token", auth.token);

    return auth;
  }

  Future<void> logout() async {
    HttpResponseModel response = await httpRequest.createInstance().delete();

    if (response.isError()) {
      throw Exception(response.body);
    }

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove("token");
  }
}
