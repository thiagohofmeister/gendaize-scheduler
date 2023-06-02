import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobile/models/authentication_model.dart';
import 'package:mobile/services/service_contract.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationService extends ServiceContract {
  AuthenticationService() : super();

  static const String resource = 'authentication';

  Future<AuthenticationModel> authenticate(String user, String password) async {
    String basicAuth = base64Encode(utf8.encode('$user:$password'));

    http.Response response = await super.httpClient.post(
      getUri(resource: resource),
      headers: {
        'authorization': 'Basic $basicAuth',
      },
    );

    if (isError(response)) {
      throw Exception(response.body);
    }

    AuthenticationModel auth = AuthenticationModel.fromJson(
      jsonDecode(response.body),
    );

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("token", auth.token);

    return auth;
  }

  Future<void> logout({required String token}) async {
    http.Response response = await super.httpClient.delete(
      getUri(resource: resource),
      headers: {
        'authorization': 'Bearer $token',
      },
    );

    if (isError(response)) {
      throw Exception(response.body);
    }

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove("token");
  }
}
