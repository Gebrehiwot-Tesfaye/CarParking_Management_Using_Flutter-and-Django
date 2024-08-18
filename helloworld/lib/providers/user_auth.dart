// TODO Implement this library.import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserAuth with ChangeNotifier {
  int? _userId;
  String? _accessToken;

  int? get userId => _userId;
  String? get accessToken => _accessToken;

  Future<void> login(int userId) async {
    _userId = userId;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_id', userId);
    await prefs.setString('access_token', accessToken!);
  }

  Future<void> logout() async {
    _userId = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
    await prefs.remove('access_token');
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('user_id')) {
      _userId = prefs.getInt('user_id');
      _accessToken = prefs.getString('access_token');
      notifyListeners();
      return true;
    }
    return false;
  }

  void setAuthData(String accessToken, int userId) {
    _accessToken = accessToken;
    _userId = userId;
    notifyListeners();
  }
}
