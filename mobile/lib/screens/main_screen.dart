import 'package:flutter/material.dart';
import 'package:mobile/components/template/nav_bottom.dart';
import 'package:mobile/components/template/nav_drawer.dart';
import 'package:mobile/models/user_model.dart';
import 'package:mobile/store/navigation_store.dart';
import 'package:mobile/store/user_logged_store.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    UserModel user = Provider.of<UserLoggedStore>(context, listen: true).user!;
    NavigationStore navigationStore =
        Provider.of<NavigationStore>(context, listen: true);

    return Scaffold(
      drawer: const NavDrawer(),
      bottomNavigationBar: const NavBottom(),
      body: navigationStore.currentScreen.widget,
    );
  }
}
