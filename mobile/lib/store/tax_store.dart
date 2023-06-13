import 'package:mobile/models/shared/response_list.dart';
import 'package:mobile/models/tax/tax_model.dart';
import 'package:mobile/services/tax_service.dart';
import 'package:mobile/store/list_store_contract.dart';

class TaxStore extends ListStoreContract<TaxModel> {
  TaxStore() : super();

  @override
  Future<ResponseList<TaxModel>> getAll({Map<String, String>? params}) {
    return TaxService().fetchAll(params);
  }
}
