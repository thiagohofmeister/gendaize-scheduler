import 'package:flutter/material.dart';
import 'package:manager/services/request/http_request.dart';

abstract class ServiceContract {
  BuildContext context;
  HttpRequest httpRequest;

  ServiceContract(this.httpRequest, this.context);
}
