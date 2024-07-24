import 'package:flutter/cupertino.dart';

class UserProvider extends ChangeNotifier {
  bool _isAdmin = false;
  String _email = '';

  bool get isAdmin => _isAdmin;
  String get email => _email;

  void setIsAdmin(bool isAdmin) {
    _isAdmin = isAdmin;
    notifyListeners();
  }

  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }
}
