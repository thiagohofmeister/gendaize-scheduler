import 'package:mobile/services/request/http_request.dart';

abstract class ServiceContract {
  HttpRequest httpRequest;

  ServiceContract(this.httpRequest);
}
