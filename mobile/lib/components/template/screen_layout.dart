import 'package:flutter/material.dart';

class ScreenLayout extends StatelessWidget {
  final List<Widget> children;

  const ScreenLayout({
    Key? key,
    required this.children,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
        child: Column(
          children: children,
        ),
      ),
    );
  }
}
