import 'package:flutter/cupertino.dart';

class UserProvider extends ChangeNotifier {
  String? nickname;
  String? password;
  String? email;

  editAttr({String? nickname, String? password, String? email}) {}

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
