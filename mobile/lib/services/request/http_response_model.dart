import 'package:http/http.dart' as http;

class HttpResponseModel extends http.Response {
  HttpResponseModel(super.body, super.statusCode);

  bool isSuccess() {
    return super.statusCode ~/ 100 == 2;
  }

  bool isError() {
    return !isSuccess();
  }
}
