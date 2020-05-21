import 'package:beerxp/pages/auth/root_page.dart';
import 'package:beerxp/services/authentication.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
void main(){
  runApp(new MaterialApp(
    home: new MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
      seconds: 3,
      navigateAfterSeconds: new RootPage(auth: new Auth()),
      imageBackground: new AssetImage('assets/images/splash.png'),
      loaderColor: Colors.deepOrange
    );
  }
}