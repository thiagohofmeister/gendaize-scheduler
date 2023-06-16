import 'package:mobile/models/shared/response_list.dart';
import 'package:mobile/services/scheduled_service.dart';
import 'package:mobile/store/list_store_contract.dart';

class ScheduledStore extends ListStoreContract {
  ScheduledStore() : super();

  @override
  Future<ResponseList> getAll({Map<String, String>? params}) {
    return ScheduledService().fetchAll(params);
  }

  Future<bool> delete(String id) async {
    bool result = await ScheduledService().delete(id);

    return result;
  }
}
