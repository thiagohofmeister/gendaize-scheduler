import 'package:http_interceptor/http/interceptor_contract.dart';
import 'package:http_interceptor/models/request_data.dart';
import 'package:http_interceptor/models/response_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthorizedInterceptor extends InterceptorContract {
  AuthorizedInterceptor() : super();

  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString('token');

    if (token != null) {
      data.headers.addAll({
        'authorization': 'Bearer $token',
      });
    }

    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    if (data.statusCode == 401) {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.remove("token");
    }

    return data;
  }
}
