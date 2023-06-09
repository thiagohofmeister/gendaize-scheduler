import 'package:mobile/models/response_list.dart';
import 'package:mobile/services/customer_service.dart';
import 'package:mobile/store/list_store_contract.dart';

class CustomerStore extends ListStoreContract {
  CustomerStore() : super();

  @override
  Future<ResponseList> getAll({Map<String, String>? params}) {
    return CustomerService().fetchAll(params);
  }

  Future<bool> delete(String id) async {
    bool result = await CustomerService().delete(id);

    await refetch();

    return result;
  }
}
