import 'package:flutter/material.dart';
import 'package:mobile/models/navigation_model.dart';

class NavigationStore extends ChangeNotifier {
  int currentScreen = 0;
  List<NavigationModel> navigation = [
    NavigationModel(icon: Icons.home, label: 'Início', slug: 'home'),
    NavigationModel(
        icon: Icons.calendar_today, label: 'Agenda', slug: 'calendar'),
    NavigationModel(icon: Icons.people, label: 'Clientes', slug: 'customers'),
  ];

  NavigationStore() : super();

  String setScreen(int screen) {
    currentScreen = screen;

    return navigation[screen].slug;
  }
}
