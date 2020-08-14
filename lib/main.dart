import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:poslabauth/blocs/location/LocationBloc.dart';
import 'package:poslabauth/blocs/user/UserBloc.dart';
import 'package:poslabauth/screens/LoginScreen.dart';
import 'package:poslabauth/services/LocationService.dart';
import 'package:poslabauth/services/UserService.dart';
import 'package:poslabauth/utils/logger.dart';

void main() {
  runApp(MultiBlocProvider(
    providers: [
       BlocProvider<UserBloc>(
        create: (context) => UserBloc(
          userService: UserService(),
          logger: Logger()
        ),
      ),
      BlocProvider<LocationBloc>(
        create: (context) => LocationBloc(
            locationService: LocationService(),
            logger: Logger()
        ),
      )
    ],
    child: App()
  ));
}

class App extends StatelessWidget {
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