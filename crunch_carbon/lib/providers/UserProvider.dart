import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  String? nickname;
  String? password;
  String? email;

  editAttr({String? nickname, String? password, String? email}) async {
    final prefs = await SharedPreferences.getInstance();
    if (nickname != null) {
      this.nickname = nickname;
      prefs.setString('nickname', nickname);
    }
    if (password != null) {
      this.password = password;
      prefs.setString('password', password);
    }
    if (email != null) {
      this.email = email;
      prefs.setString('username', email);
    }
    notifyListeners();
  }

  setAttr({
    required String nickname,
    required String password,
    required String email,
  }) {
    this.nickname = nickname;
    this.email = email;
    this.password = password;
  }
}
