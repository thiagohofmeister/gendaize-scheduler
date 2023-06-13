import 'package:flutter/material.dart';
import 'package:mobile/components/template/nav_drawer.dart';
import 'package:mobile/models/user/user_model.dart';
import 'package:mobile/store/user_logged_store.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserModel user = Provider.of<UserLoggedStore>(context).user!;

    return Scaffold(
      appBar: AppBar(),
      drawer: const NavDrawer(),
      body: Center(child: Text('Bem vindo ${user.name}')),
    );
  }
}
