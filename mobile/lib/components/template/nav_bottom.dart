import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../store/navigation_store.dart';

class NavBottom extends StatelessWidget {
  const NavBottom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int currentIndex = Provider.of<NavigationStore>(
      context,
      listen: true,
    ).currentScreenIndex;

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: Provider.of<NavigationStore>(context, listen: false)
          .navigation
          .map(
            (nav) => BottomNavigationBarItem(
              icon: Icon(nav.icon),
              label: nav.label,
            ),
          )
          .toList(),
      currentIndex: currentIndex,
      onTap: (index) {
        print(index);
        Provider.of<NavigationStore>(
          context,
          listen: false,
        ).setScreen(index);

        // if (currentIndex != index) {
        //   Navigator.pushReplacementNamed(context, routeName);
        // }
      },
    );
  }
}
