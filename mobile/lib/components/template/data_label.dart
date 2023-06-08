import 'package:flutter/material.dart';

class DataLabel extends StatelessWidget {
  final String label;
  final String info;

  const DataLabel({Key? key, required this.label, required this.info})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context).style,
        children: [
          TextSpan(
            text: '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: info),
        ],
      ),
    );
  }
}
