import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ServiceContract {
  http.Client httpClient = InterceptedClient.build(interceptors: []);

  String getBaseUrl() {
    return 'http://172.20.10.6:3001';
  }

  Uri getUri({
    required String resource,
    String? endpoint,
    Map<String, String>? params,
  }) {
    List<String> queryParams = [];

    params?.forEach((key, value) => queryParams.add('$key=$value'));

    String query = queryParams.join('&');

    Uri uri = Uri.parse(
        '${getBaseUrl()}/$resource${endpoint != null ? '/$endpoint' : ''}${query.isNotEmpty ? '?$query' : ''}');

    return uri;
  }

  bool isSuccess(http.Response response) {
    return response.statusCode ~/ 100 == 2;
  }

  bool isError(http.Response response) {
    return !isSuccess(response);
  }

  Future<Map<String, String>> defaultHeaders({bool isLogged = true}) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (isLogged) {
      String? token = await getToken();
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  Future<String?> getToken() async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();

    return sharedPref.getString('token');
  }
}
