import 'package:flutter/material.dart';
import 'package:mobile/models/shared/navigation_model.dart';
import 'package:mobile/screens/customer/customer_list_screen.dart';
import 'package:mobile/screens/home_screen.dart';
import 'package:mobile/screens/scheduled/scheduled_list_screen.dart';

class NavigationStore extends ChangeNotifier {
  List<NavigationModel> navigation = [
    NavigationModel(
      icon: Icons.home,
      label: 'Início',
      slug: 'main',
      widget: const HomeScreen(),
    ),
    NavigationModel(
      icon: Icons.calendar_today,
      label: 'Agenda',
      slug: 'scheduled-list',
      widget: const ScheduledListScreen(),
    ),
    NavigationModel(
      icon: Icons.people,
      label: 'Clientes',
      slug: 'customer-list',
      widget: const CustomerListScreen(),
    ),
  ];

  int currentScreenIndex = 0;
  late NavigationModel currentScreen = navigation[currentScreenIndex];

  NavigationStore() : super();

  String setScreen(int screen) {
    currentScreenIndex = screen;
    currentScreen = navigation[screen];

    notifyListeners();

    return navigation[screen].slug;
  }

  String setNameScreen(String slug) {
    currentScreenIndex =
        navigation.indexWhere((element) => element.slug == slug);
    currentScreen = navigation[currentScreenIndex];

    notifyListeners();

    return navigation[currentScreenIndex].slug;
  }
}
