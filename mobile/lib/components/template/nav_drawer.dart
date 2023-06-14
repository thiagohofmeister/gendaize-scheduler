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
            leading: const Icon(Icons.home),
            title: const Text('Início'),
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                'main',
                (route) => true,
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.business),
            title: const Text('Filiais'),
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                'headquarter-list',
                (route) => true,
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.attach_money),
            title: const Text('Taxas'),
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                'tax-list',
                (route) => true,
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.category),
            title: const Text('Serviços'),
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                'service-list',
                (route) => true,
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Desconectar'),
            onTap: () {
              Provider.of<AuthenticationStore>(context, listen: false).logout();
              Navigator.pushNamedAndRemoveUntil(
                context,
                'signin',
                (route) => true,
              );
            },
          ),
        ],
      ),
    );
  }
}
