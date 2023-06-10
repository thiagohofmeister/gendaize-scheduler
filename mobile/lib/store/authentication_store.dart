import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/authentication_service.dart';

class AuthenticationStore extends ChangeNotifier {
  AuthenticationStore() : super();

  Future<void> logout() async {
    await AuthenticationService().logout();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove('token');
  }
}
