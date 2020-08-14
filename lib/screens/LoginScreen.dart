import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poslabauth/blocs/user/UserBloc.dart';
import 'package:poslabauth/blocs/user/UserEvent.dart';
import 'package:poslabauth/blocs/user/UserState.dart';
import 'package:poslabauth/models/User.dart';
import 'package:poslabauth/screens/HomeScreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  void redirectHomeScreen() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        body: SafeArea(
          child: BlocConsumer<UserBloc, UserState>(
            listener: (context, state) {
              if (state is UserIsAuthenticated) {
                redirectHomeScreen();
              }
            },
            builder: (blocContext, state) {
              return Column(
                children: <Widget>[
                  SizedBox(
                    height: 50,
                  ),
                  ScreenTitleContainer(),
                  SizedBox(
                    height: 40,
                  ),
                  BiometricContainer(),
                  SizedBox(
                    height: 40,
                  ),
                  if (state is UserAuthenticationFailed)
                    Text(state.errorMessage),
                  SignInWithFacebook(),
                  SizedBox(
                    height: 20,
                  ),
                  SignInWithInstagram()
                ],
              );
            },
          ),
        ));
  }

  Widget ScreenTitleContainer() => Container(
        margin: EdgeInsets.only(top: 30),
        child: Center(
            child: Text(
          "POSLABS AUTH",
          style: TextStyle(fontSize: 30),
        )),
      );

  Widget BiometricContainer() => Container(
          child: Column(
        children: <Widget>[
          Image.asset(
            "assets/images/touch_id_icon.png",
            width: 50,
            height: 50,
          ),
          SizedBox(height: 10),
          Text(
            "Use fingerprint to login",
            style: TextStyle(color: Colors.grey[600]),
          )
        ],
      ));

  Widget SignInWithFacebook() {
    final userBlock = BlocProvider.of<UserBloc>(context);
    return Ink(
      width: 300,
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: InkWell(
        splashColor: Colors.grey[200],
        onTap: () => userBlock.add(UserFacebookSignUpEvent()),
        child: Row(
          children: <Widget>[
            Image.asset(
              'assets/images/facebook_icon.png',
              width: 50,
              height: 50,
            ),
            SizedBox(width: 50),
            Text(
              "Continue with facebook",
            )
          ],
        ),
      ),
    );
  }

  Widget SignInWithInstagram() => Ink(
        width: 300,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: InkWell(
          splashColor: Colors.grey[200],
          onTap: () => {},
          child: Row(
            children: <Widget>[
              Image.asset(
                'assets/images/instagram_icon.png',
                width: 50,
                height: 50,
              ),
              SizedBox(width: 50),
              Text(
                "Sign up with instagram",
              )
            ],
          ),
        ),
      );

  @override
  void dispose() {
    super.dispose();
    BlocProvider.of<UserBloc>(context).close();
  }
}
