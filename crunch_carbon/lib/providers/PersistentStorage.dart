import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoredData extends ChangeNotifier {
  Future<bool> checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    return token != null;
  }

  void storeLodin(
      String username, String password, String nickname, String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', token);
    prefs.setString('password', password);
    prefs.setString('username', username);
    prefs.setString('nickname', nickname);
  }
}
