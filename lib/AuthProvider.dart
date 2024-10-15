import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;
  String? _userName;

  bool get isLoggedIn => _isLoggedIn;
  String? get userName => _userName;

  void login(String userName) {
    _userName = userName; 
    _isLoggedIn = true; 
    notifyListeners(); 
  }

  void logout() {
    _isLoggedIn = false;
    _userName = null; 
    notifyListeners();
  }
}