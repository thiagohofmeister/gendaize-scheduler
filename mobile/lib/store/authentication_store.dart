import 'package:flutter/material.dart';

import '../services/authentication_service.dart';

class AuthenticationStore extends ChangeNotifier {
  AuthenticationStore() : super();

  Future<void> logout(BuildContext context) async {
    await AuthenticationService(context).logout();
  }
}
