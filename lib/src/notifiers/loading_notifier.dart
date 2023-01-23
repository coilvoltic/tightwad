import 'package:flutter/material.dart';

class LoadingNotifier extends ChangeNotifier {

  bool _isLoading = false;

  void setIsLoading() {
    if (!_isLoading) {
      _isLoading = true;
      notifyListeners();
    }
  }

  void unsetIsLoading() {
    if (_isLoading) {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool get getIsLoading => _isLoading;

}