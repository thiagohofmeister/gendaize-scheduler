import 'package:flutter/material.dart';

class NavigationModel {
  IconData icon;
  String label;
  String slug;
  Widget widget;
  List<Widget>? actions;

  NavigationModel({
    required this.icon,
    required this.label,
    required this.slug,
    required this.widget,
    this.actions,
  });
}
