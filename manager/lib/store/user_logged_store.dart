import 'package:flutter/material.dart';
import 'package:manager/models/user/user_model.dart';
import 'package:manager/store/store_contract.dart';

import '../services/user_service.dart';

class UserLoggedStore extends StoreContract {
  UserModel? user;

  UserLoggedStore() : super();

  Future<void> fetch(BuildContext context, String token) async {
    setLoading(true);
    user = await UserService(context).getLogged();
    setLoading(false);
  }
}
