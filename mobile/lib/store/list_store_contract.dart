import 'package:mobile/models/shared/response_list.dart';
import 'package:mobile/store/store_contract.dart';

abstract class ListStoreContract<Item> extends StoreContract {
  ListStoreContract() : super();

  bool isFirstFetch = true;
  List<Item> items = [];
  int total = 0;

  Future<void> _fetch(
      {Map<String, String>? params, bool notifyOnStarting = false}) async {
    setLoading(true);

    if (notifyOnStarting) {
      notifyListeners();
    }

    ResponseList<Item> response = await getAll(params: params);

    items = response.items;
    total = response.total;

    afterFetchAll();

    setLoading(false);

    notifyListeners();
  }

  Future<void> initialFetch({Map<String, String>? params}) async {
    if (!isFirstFetch) {
      return;
    }

    await _fetch(params: params);
  }

  Future<void> refetch({Map<String, String>? params}) async {
    await _fetch(params: params, notifyOnStarting: true);
  }

  Future<ResponseList<Item>> getAll({Map<String, String>? params});

  hasNoData() {
    return items.isEmpty;
  }

  Future<void> afterFetchAll() async {}
}
