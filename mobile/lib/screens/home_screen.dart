import 'package:flutter/material.dart';
import 'package:mobile/components/template/nav_bottom.dart';
import 'package:mobile/components/template/nav_drawer.dart';
import 'package:mobile/models/user_model.dart';
import 'package:mobile/store/user_logged_store.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    UserModel user = Provider.of<UserLoggedStore>(context, listen: true).user!;

    return Scaffold(
      appBar: AppBar(),
      drawer: const NavDrawer(),
      bottomNavigationBar: const NavBottom(),
      body: Container(
        alignment: Alignment.center,
        child: Text('Bem-vindo ${user.name}'),
      ),
    );
  }
}
