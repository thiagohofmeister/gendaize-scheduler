import 'package:flutter/material.dart';
import 'package:manager/models/customer/customer_model.dart';
import 'package:manager/models/shared/response_list.dart';
import 'package:manager/services/customer_service.dart';
import 'package:manager/store/list_store_contract.dart';

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
