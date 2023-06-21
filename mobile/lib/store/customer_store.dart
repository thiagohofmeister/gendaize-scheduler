import 'package:flutter/material.dart';
import 'package:mobile/models/customer/customer_model.dart';
import 'package:mobile/models/shared/response_list.dart';
import 'package:mobile/services/customer_service.dart';
import 'package:mobile/store/list_store_contract.dart';

class CustomerStore extends ListStoreContract<CustomerModel> {
  CustomerStore() : super();

  @override
  Future<ResponseList<CustomerModel>> getAll(BuildContext context,
      {Map<String, String>? params}) {
    return CustomerService(context).fetchAll(params);
  }

  Future<bool> delete(BuildContext context, String id) async {
    bool result = await CustomerService(context).delete(id);

    return result;
  }

  Future<bool> deleteAddress(
    BuildContext context,
    String id,
    String addressId,
  ) async {
    bool result = await CustomerService(context).deleteAddress(id, addressId);

    return result;
  }
}
