import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobile/models/user_model.dart';
import 'package:mobile/services/service_contract.dart';

class UserService extends ServiceContract {
  static const String resource = 'user';

  Future<UserModel?> getLogged() async {
    http.Response response = await super.httpClient.get(
      getUri(
        resource: resource,
        endpoint: 'me',
      ),
      headers: {...(await defaultHeaders())},
    );

    if (isError(response)) {
      throw Exception(response.body);
    }

    return UserModel.fromMap(
      jsonDecode(response.body),
    );
  }
}
