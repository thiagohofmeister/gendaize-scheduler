import 'package:flutter/material.dart';
import 'package:manager/models/service/service_model.dart';
import 'package:manager/models/shared/response_list.dart';
import 'package:manager/services/service_service.dart';
import 'package:manager/store/list_store_contract.dart';

class ServiceStore extends ListStoreContract<ServiceModel> {
  ServiceStore() : super();

  @override
  Future<ResponseList<ServiceModel>> getAll(BuildContext context,
      {Map<String, String>? params}) {
    return ServiceService(context).fetchAll(params);
  }
}
