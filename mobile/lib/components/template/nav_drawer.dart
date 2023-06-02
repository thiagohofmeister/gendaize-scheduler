import 'package:flutter/material.dart';
import 'package:mobile/store/authentication_store.dart';
import 'package:mobile/store/user_logged_store.dart';
import 'package:provider/provider.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Consumer<UserLoggedStore>(
              builder: (context, store, child) {
                return Text('Olá ${store.user!.name}!');
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Desconectar'),
            onTap: () {
              Provider.of<AuthenticationStore>(context, listen: false).logout();
              Navigator.pushReplacementNamed(context, 'signin');
            },
          ),
        ],
      ),
    );
  }
}
