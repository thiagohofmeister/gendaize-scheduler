import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobile/models/user_model.dart';
import 'package:mobile/services/service_contract.dart';

class UserService extends ServiceContract {
  String token;

  UserService({required this.token}) : super();

  static const String resource = 'user';

  Future<UserModel?> getLogged() async {
    http.Response response = await super.httpClient.get(
      getUri(
        resource: resource,
        endpoint: 'me',
      ),
      headers: {
        'authorization': 'Bearer $token',
      },
    );

    if (isError(response)) {
      throw Exception(response.body);
    }

    return UserModel.fromJson(
      jsonDecode(response.body),
    );
  }
}
