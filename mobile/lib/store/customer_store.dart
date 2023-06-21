import 'package:mobile/models/customer/customer_model.dart';
import 'package:mobile/models/shared/response_list.dart';
import 'package:mobile/services/customer_service.dart';
import 'package:mobile/store/list_store_contract.dart';

class CustomerStore extends ListStoreContract<CustomerModel> {
  CustomerStore() : super();

  @override
  Future<ResponseList<CustomerModel>> getAll({Map<String, String>? params}) {
    return CustomerService().fetchAll(params);
  }

  Future<bool> delete(String id) async {
    bool result = await CustomerService().delete(id);

    return result;
  }

  Future<bool> deleteAddress(String id, String addressId) async {
    bool result = await CustomerService().deleteAddress(id, addressId);

    return result;
  }
}
