import 'package:mobile/models/user_model.dart';
import 'package:mobile/store/store_contract.dart';

import '../services/user_service.dart';

class UserLoggedStore extends StoreContract {
  UserModel? user;

  UserLoggedStore() : super();

  Future<void> fetch(String token) async {
    setLoading(true);
    user = await UserService().getLogged();
    setLoading(false);
  }
}
