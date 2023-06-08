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
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Início',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'Agendados',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.schedule),
          label: 'Marcar',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: 'Clientes',
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
