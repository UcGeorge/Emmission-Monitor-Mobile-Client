import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class API extends ChangeNotifier {
  String? token;
  String? name;

  API() {
    getToken();
  }

  getToken() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
  }

  Future<LoginStatus> login(String username, String password) async {
    try {
      print('Logging in');
      var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
      var request = http.Request(
          'GET', Uri.parse('https://crunch-carbon.herokuapp.com/user/login'));
      request.bodyFields = {'username': username, 'password': password};
      request.headers.addAll(headers);

      print('Sending request');
      http.StreamedResponse response = await request.send();
      String responseBody = await response.stream.bytesToString();

      print('Got response');

      if (response.statusCode == 200) {
        print(responseBody);
        try {
          Map<String, dynamic> jsonBody = jsonDecode(responseBody);
          token = jsonBody['token'];
          name = jsonBody['name'];
          return LoginStatus.Success;
        } catch (e) {
          print('Json parse error: $e');
          return LoginStatus.Faliure;
        }
      } else {
        print(responseBody);
        return LoginStatus.Faliure;
      }
    } catch (e) {
      print(e);
      return LoginStatus.Faliure;
    }
  }

  Future<SignupStatus> signup(
      String name, String username, String password) async {
    try {
      print('Signing up');
      var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
      var request = http.Request(
        'POST',
        Uri.parse('https://crunch-carbon.herokuapp.com/user/signup'),
      );
      request.bodyFields = {
        'username': username,
        'password': password,
        'name': name
      };
      request.headers.addAll(headers);

      print('Sending request');
      http.StreamedResponse response = await request.send();
      String responseBody = await response.stream.bytesToString();

      print('Got response');

      if (response.statusCode == 200) {
        print(responseBody);
        try {
          Map<String, dynamic> jsonBody = jsonDecode(responseBody);
          token = jsonBody['token'];
          return SignupStatus.Success;
        } catch (e) {
          print('Json parse error: $e');
          return SignupStatus.Faliure;
        }
      } else {
        print(responseBody);
        return SignupStatus.Faliure;
      }
    } catch (e) {
      print(e);
      return SignupStatus.Faliure;
    }
  }

  Future<UpdateStatus> update(
      String name, String username, String password) async {
    print('Token: $token\nUsername: $username\nPassword: $password');
    try {
      print('Updating profile');
      var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
      var request = http.Request(
          'PUT', Uri.parse('https://crunch-carbon.herokuapp.com/user/update'));
      request.bodyFields = {
        'username': username,
        'password': password,
        'name': name,
        'token': token ?? 'undefined'
      };
      request.headers.addAll(headers);

      print('Sending request');
      http.StreamedResponse response = await request.send();
      String responseBody = await response.stream.bytesToString();

      print('Got response');

      if (response.statusCode == 200) {
        print(responseBody);
        try {
          // Map<String, dynamic> jsonBody = jsonDecode(responseBody);
          return UpdateStatus.Success;
        } catch (e) {
          print('Json parse error: $e');
          return UpdateStatus.Faliure;
        }
      } else {
        print(responseBody);
        return UpdateStatus.Faliure;
      }
    } catch (e) {
      print(e);
      return UpdateStatus.Faliure;
    }
  }
}

enum LoginStatus { LoggedOut, Success, Faliure }
enum SignupStatus { LoggedOut, Success, Faliure }
enum UpdateStatus { Undefined, Success, Faliure }
