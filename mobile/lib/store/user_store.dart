import 'package:flutter/material.dart';
import 'package:mobile/models/shared/response_list.dart';
import 'package:mobile/models/user/user_model.dart';
import 'package:mobile/services/user_service.dart';
import 'package:mobile/store/list_store_contract.dart';

class UserStore extends ListStoreContract<UserModel> {
  UserStore() : super();

  @override
  Future<ResponseList<UserModel>> getAll(BuildContext context,
      {Map<String, String>? params}) {
    return UserService(context).fetchAll(params);
  }
}
