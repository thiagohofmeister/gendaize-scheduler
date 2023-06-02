import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/http.dart';

abstract class ServiceContract {
  ServiceContract();

  http.Client httpClient = InterceptedClient.build(interceptors: []);

  String getBaseUrl() {
    return 'https://api-scheduler.gendaize.com.br';
  }

  Uri getUri({
    required String resource,
    String? endpoint,
    Map<String, String>? params,
  }) {
    List<String> queryParams = [];

    params?.forEach((key, value) => queryParams.add('$key=$value'));

    String query = queryParams.join('&');

    return Uri.parse(
        '${getBaseUrl()}/$resource${endpoint != null ? '/$endpoint' : ''}${query.isNotEmpty ? '?$query' : ''}');
  }

  bool isSuccess(http.Response response) {
    return response.statusCode ~/ 100 == 2;
  }

  bool isError(http.Response response) {
    return !isSuccess(response);
  }
}
