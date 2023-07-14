import 'dart:async';

import 'package:flutter/material.dart';
import 'package:manager/models/shared/response_list.dart';
import 'package:manager/services/scheduled_service.dart';
import 'package:manager/store/list_store_contract.dart';

class ScheduledStore extends ListStoreContract {
  ScheduledStore() : super();

  @override
  Future<ResponseList> getAll(
    BuildContext context, {
    Map<String, String>? params,
  }) {
    return ScheduledService(context).fetchAll(params);
  }

  Future<bool> delete(BuildContext context, id) async {
    bool result = await ScheduledService(context).delete(id);

    return result;
  }
}
