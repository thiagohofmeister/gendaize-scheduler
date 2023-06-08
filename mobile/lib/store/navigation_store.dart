import 'package:flutter/material.dart';

class NavigationStore extends ChangeNotifier {
  int currentScreen = 0;
  List<String> screens = ['home', 'calendar', 'schedule', 'customers'];

  NavigationStore() : super();

  String setScreen(int screen) {
    currentScreen = screen;

    return screens[screen];
  }
}
