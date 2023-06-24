import 'package:flutter/material.dart';
import 'package:mobile/components/template/screen_progress_indicator.dart';

class ScreenLayout extends StatelessWidget {
  final List<Widget>? children;
  final Widget? child;
  final bool isLoading;

  const ScreenLayout({
    Key? key,
    this.children,
    this.child,
    this.isLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const ScreenProgressIndicator();
    }

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children!,
          ),
        ),
      );
    }

    return Container();
  }
}
