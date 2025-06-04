// token_provider.dart
import 'package:flutter/material.dart';

class TokenProvider with ChangeNotifier {
  String? _token;

  String? get token {
    print('[GET] Token: $_token');
    return _token;
  }

  void setToken(String? token) {
    print('[SET] Token: $token');
    _token = token;
    notifyListeners();
  }
}
