import 'package:flutter/material.dart';
import 'package:manager/models/shared/response_list.dart';
import 'package:manager/models/user/user_model.dart';
import 'package:manager/services/user_service.dart';
import 'package:manager/store/list_store_contract.dart';

class UserStore extends ListStoreContract<UserModel> {
  UserStore() : super();

  @override
  Future<ResponseList<UserModel>> getAll(BuildContext context,
      {Map<String, String>? params}) {
    return UserService(context).fetchAll(params);
  }
}
