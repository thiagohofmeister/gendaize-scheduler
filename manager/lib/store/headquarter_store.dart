import 'package:flutter/material.dart';
import 'package:manager/models/headquarter/headquarter_model.dart';
import 'package:manager/models/shared/response_list.dart';
import 'package:manager/services/headquarter_service.dart';
import 'package:manager/store/list_store_contract.dart';

class HeadquarterStore extends ListStoreContract<HeadquarterModel> {
  HeadquarterStore() : super();

  @override
  Future<ResponseList<HeadquarterModel>> getAll(BuildContext context,
      {Map<String, String>? params}) {
    return HeadquarterService(context).fetchAll(params);
  }
}
