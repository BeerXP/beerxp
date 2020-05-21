import 'package:flutter/material.dart';
import 'login_screen.dart';

void main() => runApp(LoginMain());

class LoginMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BeerXP Login',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        accentColor: Colors.blue,
        cursorColor: Colors.blue,
        textTheme: TextTheme(
          headline3: TextStyle(
            fontFamily: 'OpenSans',
            fontSize: 45.0,
            color: Colors.orange,
          ),
          button: TextStyle(
            fontFamily: 'OpenSans',
          ),
          subtitle1: TextStyle(fontFamily: 'NotoSans'),
          bodyText2: TextStyle(fontFamily: 'NotoSans'),
        ),
      ),
      home: LoginScreen(),
    );
  }
}