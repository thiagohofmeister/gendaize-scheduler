import 'package:flutter/material.dart';
import 'package:mobile/components/template/nav_drawer.dart';
import 'package:mobile/models/user_model.dart';
import 'package:mobile/store/user_logged_store.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../store/authentication_store.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;

  void handleLogin() {
    SharedPreferences.getInstance().then((sharedPreferences) {
      String? token = sharedPreferences.getString('token');

      if (token == null) {
        Navigator.pushReplacementNamed(context, 'signin');
        return;
      }

      Provider.of<UserLoggedStore>(
        context,
        listen: false,
      ).fetch(token).then((value) {
        setState(() {
          isLoading = false;
        });

        Provider.of<AuthenticationStore>(context, listen: false)
            .setToken(token);
      }).catchError((onError) {
        Navigator.pushReplacementNamed(context, 'signin');
      });
    });
  }

  @override
  void initState() {
    super.initState();
    handleLogin();
  }

  @override
  Widget build(BuildContext context) {
    UserModel? user = Provider.of<UserLoggedStore>(context, listen: true).user;

    return Scaffold(
      appBar: AppBar(),
      drawer: const NavDrawer(),
      body: Container(
        alignment: Alignment.center,
        child: isLoading || user == null
            ? const CircularProgressIndicator()
            : Text('Bem-vindo ${user.name}'),
      ),
    );
  }
}
