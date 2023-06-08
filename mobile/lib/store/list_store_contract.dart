import 'package:mobile/models/response_list.dart';
import 'package:mobile/store/store_contract.dart';

abstract class ListStoreContract<Item> extends StoreContract {
  ListStoreContract() : super();

  bool isFirstFetch = true;
  List<Item> items = [];
  int total = 0;

  _fetch({Map<String, String>? params, bool notifyOnStarting = false}) async {
    setLoading(true);

    if (notifyOnStarting) {
      notifyListeners();
    }

    ResponseList<Item> response = await getAll(params: params);

    items = response.items;
    total = response.total;

    setLoading(false);

    notifyListeners();
  }

  initialFetch({Map<String, String>? params}) async {
    if (!isFirstFetch) {
      return;
    }

    _fetch(params: params);
  }

  refetch({Map<String, String>? params}) async {
    _fetch(params: params, notifyOnStarting: true);
  }

  Future<ResponseList<Item>> getAll({Map<String, String>? params});

  hasNoData() {
    return items.isEmpty;
  }
}
