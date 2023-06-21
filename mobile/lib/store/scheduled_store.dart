import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile/models/shared/response_list.dart';
import 'package:mobile/services/scheduled_service.dart';
import 'package:mobile/store/list_store_contract.dart';

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
