import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PosLab Auth',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {

  @override
  _LoginScreenState createState() => _LoginScreenState();

}

class _LoginScreenState extends State<LoginScreen> {

  void loginUsingFacebook() async {
      final facebookLogin = FacebookLogin();
      final result = await facebookLogin.logIn(['email']);
      final token = result.accessToken.token;
      final graphResponse = await http.get(
          'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${token}');
      final profile = json.decode(graphResponse.body);
      print("User profile $profile");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //loginUsingFacebook();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
            children: <Widget>[
              SizedBox(height: 50,),
              Container(
                margin: EdgeInsets.only(top: 30),
                child: Center(
                    child: Text("POSLABS AUTH",
                    style: TextStyle(fontSize: 30),)
                ),
              ),
              SizedBox(height: 40,),
              Container(
                child: Column(
                  children: <Widget>[
                    Image.asset("assets/images/touch_id_icon.png",width: 50, height: 50,),
                    SizedBox(height: 10),
                    Text("Use fingerprint to login",
                      style: TextStyle(color: Colors.grey[600]),)
                  ],
                )
              ),
              SizedBox(height: 40,),
              Container(
                child: RaisedButton.icon(
                    onPressed: () {
                      this.loginUsingFacebook();
                    },
                    icon: Icon(Icons.face),
                    label: Text(
                        "Continue with facebook",
                        style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.blue[800],
                ),
              ),
              Container(
                child: RaisedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.face),
                  label: Text(
                    "Sign in with instagram",
                  ),
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 30,),
              Container(
                  width: 300,
                  child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      color: Colors.black12,
                      width: 120,
                      height: 1,
                    ),
                    Text("OR"),
                    Container(
                      color: Colors.black12,
                      width: 120,
                      height: 1,
                    ),
                  ],

              )),
              SizedBox(height: 30,),
              Container(
                child: RaisedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.face),
                  label: Text(
                    "Sign up with facebook",
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.blue[800],
                ),
              ),
              Container(
                child: RaisedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.face),
                  label: Text(
                    "Sign up with instagram",
                  ),
                  color: Colors.white,
                ),
              ),

            ],)
        ,
      ),
    );
  }
}
