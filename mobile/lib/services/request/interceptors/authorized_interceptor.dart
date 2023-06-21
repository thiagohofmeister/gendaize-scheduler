import 'package:flutter/material.dart';
import 'package:http_interceptor/http/interceptor_contract.dart';
import 'package:http_interceptor/models/request_data.dart';
import 'package:http_interceptor/models/response_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthorizedInterceptor extends InterceptorContract {
  BuildContext context;

  AuthorizedInterceptor(this.context) : super();

  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    return SharedPreferences.getInstance().then((sharedPreferences) {
      String? token = sharedPreferences.getString('token');

      if (token == null) {
        Navigator.pushNamedAndRemoveUntil(context, 'signin', (route) => true);
      }

      data.headers.addAll({
        'authorization': 'Bearer $token',
      });

      return data;
    });
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    if (data.statusCode == 401) {
      return SharedPreferences.getInstance().then((sharedPreferences) {
        sharedPreferences.remove("token");
        Navigator.pushNamedAndRemoveUntil(context, 'signin', (route) => true);
        return data;
      });
    }

    return data;
  }
}
