import 'package:flutter/material.dart';

class ScreenProgressIndicator extends StatelessWidget {
  const ScreenProgressIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(50),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}
