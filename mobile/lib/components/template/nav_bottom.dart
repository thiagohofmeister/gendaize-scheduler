import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../store/navigation_store.dart';

class NavBottom extends StatelessWidget {
  const NavBottom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int currentIndex = Provider.of<NavigationStore>(
      context,
      listen: false,
    ).currentScreen;

    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Início',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Alunos',
        )
      ],
      currentIndex: currentIndex,
      onTap: (index) {
        String routeName = Provider.of<NavigationStore>(
          context,
          listen: false,
        ).setScreen(index);

        if (currentIndex != index) {
          Navigator.pushReplacementNamed(context, routeName);
        }
      },
    );
  }
}
