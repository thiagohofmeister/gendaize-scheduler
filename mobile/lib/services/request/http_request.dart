import 'package:http/http.dart' as http;
import 'package:http_interceptor/http/http.dart';
import 'package:mobile/services/request/http_response_model.dart';
import 'package:mobile/services/request/interceptors/authorized_interceptor.dart';

class HttpRequest<T> {
  http.Client? instance;
  Map<String, String>? params;
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  String? endpoint;
  T? payload;
  String resource;

  HttpRequest(this.resource);

  String getBaseUrl() {
    if (const String.fromEnvironment('ENV') == 'prod') {
      return 'https://api-scheduler.gendaize.com.br';
    }

    return 'http://localhost:3001';
  }

  HttpRequest<T> createInstance({bool isLogged = true}) {
    List<InterceptorContract> interceptors = [];

    if (isLogged) {
      interceptors.add(AuthorizedInterceptor());
    }

    instance = InterceptedClient.build(interceptors: interceptors);

    return this;
  }

  Uri getUri() {
    List<String> queryParams = [];

    params?.forEach((key, value) => queryParams.add('$key=$value'));

    String query = queryParams.join('&');

    Uri uri = Uri.parse(
        '${getBaseUrl()}/$resource${endpoint != null ? '/$endpoint' : ''}${query.isNotEmpty ? '?$query' : ''}');

    print(uri);

    return uri;
  }

  HttpRequest addHeader(String key, String value) {
    headers[key] = value;

    return this;
  }

  HttpRequest withEndpoint(String endpoint) {
    this.endpoint = endpoint;
    return this;
  }

  HttpRequest withPayload(T payload) {
    this.payload = payload;
    return this;
  }

  HttpRequest withParams(Map<String, String>? params) {
    if (params != null) {
      this.params = params;
    }

    return this;
  }

  Future<HttpResponseModel> get({bool isLogged = true}) async {
    http.Response response = await instance!.get(getUri(), headers: headers);

    return HttpResponseModel(response.body, response.statusCode);
  }

  Future<HttpResponseModel> post() async {
    http.Response response =
        await instance!.post(getUri(), headers: headers, body: payload);

    return HttpResponseModel(response.body, response.statusCode);
  }

  Future<HttpResponseModel> put() async {
    http.Response response =
        await instance!.put(getUri(), headers: headers, body: payload);

    return HttpResponseModel(response.body, response.statusCode);
  }

  Future<HttpResponseModel> patch() async {
    http.Response response =
        await instance!.patch(getUri(), headers: headers, body: payload);

    return HttpResponseModel(response.body, response.statusCode);
  }

  Future<HttpResponseModel> delete() async {
    http.Response response =
        await instance!.delete(getUri(), headers: headers, body: payload);

    return HttpResponseModel(response.body, response.statusCode);
  }
}
