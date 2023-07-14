import 'package:flutter/material.dart';
import 'package:manager/models/shared/response_list.dart';
import 'package:manager/store/store_contract.dart';

abstract class ListStoreContract<Item> extends StoreContract {
  ListStoreContract() : super();

  bool isFirstFetch = true;
  List<Item> items = [];
  int total = 0;

  Future<void> _fetch(
    BuildContext context, {
    Map<String, String>? params,
    bool notifyOnStarting = false,
  }) async {
    setLoading(true);

    if (notifyOnStarting) {
      notifyListeners();
    }

    ResponseList<Item> response = await getAll(context, params: params);

    items = response.items;
    total = response.total;

    afterFetchAll();

    setLoading(false);

    notifyListeners();
  }

  Future<void> initialFetch(BuildContext context,
      {Map<String, String>? params}) async {
    if (!isFirstFetch) {
      return;
    }

    await _fetch(context, params: params);
  }

  Future<void> refetch(BuildContext context,
      {Map<String, String>? params}) async {
    await _fetch(context, params: params, notifyOnStarting: true);
  }

  Future<ResponseList<Item>> getAll(
    BuildContext context, {
    Map<String, String>? params,
  });

  hasNoData() {
    return items.isEmpty;
  }

  Future<void> afterFetchAll() async {}
}
