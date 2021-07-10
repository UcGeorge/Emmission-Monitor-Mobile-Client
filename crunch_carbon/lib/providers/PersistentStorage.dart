import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoredData extends ChangeNotifier {
  Future<bool> checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    return token != null;
  }
}
