import 'package:flutter/material.dart';
import 'package:mobile/store/authentication_store.dart';
import 'package:mobile/store/user_logged_store.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
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
        Navigator.pushReplacementNamed(context, 'home');
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
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: const CircularProgressIndicator(),
      ),
    );
  }
}
