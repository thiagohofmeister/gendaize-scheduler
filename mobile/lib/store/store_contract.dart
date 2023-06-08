import 'package:flutter/material.dart';

class StoreContract extends ChangeNotifier {
  StoreContract() : super();

  bool isLoading = false;

  setLoading(bool value) {
    isLoading = value;
  }
}
