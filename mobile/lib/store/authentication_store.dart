import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/authentication_service.dart';

class AuthenticationStore extends ChangeNotifier {
  String? token;

  AuthenticationStore() : super();

  void setToken(String token) {
    this.token = token;
  }

  Future<void> logout() async {
    await AuthenticationService().logout(token: token!);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove('token');
  }
}
