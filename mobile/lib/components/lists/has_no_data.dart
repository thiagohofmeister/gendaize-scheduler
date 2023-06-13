import 'package:flutter/material.dart';

class HasNoData extends StatelessWidget {
  String message;
  String? subMessage;

  HasNoData({Key? key, required this.message, this.subMessage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          subMessage != null
              ? Text(
                  subMessage!,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
