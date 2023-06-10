import 'dart:convert';

import 'package:mobile/models/user_model.dart';
import 'package:mobile/services/request/http_request.dart';
import 'package:mobile/services/request/http_response_model.dart';
import 'package:mobile/services/service_contract.dart';

class UserService extends ServiceContract {
  UserService() : super(HttpRequest('user'));

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
