import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'package:poslabauth/models/User.dart';
import 'dart:convert';

class UserService {

  Future<User> facebookSignUp() async {
    final facebookLogin = FacebookLogin();
    final result = await facebookLogin.logIn(['email']);
    final token = result.accessToken.token;
    final graphResponse = await http.get(
        'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=$token');
    final profile = jsonDecode(graphResponse.body);
    return User.fromJson(profile);
  }

}