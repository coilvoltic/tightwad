import 'package:flutter/material.dart';

class LoadingNotifier extends ChangeNotifier {

  bool _isLoading = false;

  void setIsLoading() {
    _isLoading = true;
    notifyListeners();
  }

  void unsetIsLoading() {
    _isLoading = false;
    notifyListeners();
  }

  bool get getIsLoading => _isLoading;

}