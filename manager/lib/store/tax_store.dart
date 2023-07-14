import 'package:flutter/material.dart';
import 'package:manager/models/shared/response_list.dart';
import 'package:manager/models/tax/tax_model.dart';
import 'package:manager/services/tax_service.dart';
import 'package:manager/store/list_store_contract.dart';

class TaxStore extends ListStoreContract<TaxModel> {
  TaxStore() : super();

  @override
  Future<ResponseList<TaxModel>> getAll(BuildContext context,
      {Map<String, String>? params}) {
    return TaxService(context).fetchAll(params);
  }
}
