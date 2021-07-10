import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class LoginSignup extends ChangeNotifier {
  Future<LoginStatus> login(BuildContext context) async {
    print('Logging in');
    var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
    var request =
        http.Request('GET', Uri.parse('http://192.168.0.100:3000/user/login'));
    request.bodyFields = {
      'username': 'petegeorge20005@gmail.com',
      'password': 'P@\$\$w0rd'
    };
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
    return LoginStatus.Success;
  }
}

enum LoginStatus { Success }
