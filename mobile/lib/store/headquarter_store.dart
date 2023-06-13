import 'package:mobile/models/headquarter/headquarter_model.dart';
import 'package:mobile/models/shared/response_list.dart';
import 'package:mobile/services/headquarter_service.dart';
import 'package:mobile/store/list_store_contract.dart';

class HeadquarterStore extends ListStoreContract<HeadquarterModel> {
  HeadquarterStore() : super();

  @override
  Future<ResponseList<HeadquarterModel>> getAll({Map<String, String>? params}) {
    return HeadquarterService().fetchAll(params);
  }
}
