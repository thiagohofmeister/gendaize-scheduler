import 'package:flutter/material.dart';

class ScreenLayout extends StatelessWidget {
  final List<Widget>? children;
  final Widget? child;

  const ScreenLayout({
    Key? key,
    this.children,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (child != null) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
        child: child,
      );
    }

    if (children != null) {
      return SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
          child: Column(
            children: children!,
          ),
        ),
      );
    }

    return Container();
  }
}
