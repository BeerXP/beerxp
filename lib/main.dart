import 'package:beerxp/pages/auth/root_page.dart';
import 'package:beerxp/services/authentication.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

 FirebaseAnalytics analytics = FirebaseAnalytics();
 FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);

void main(){
  // Set `enableInDevMode` to true to see reports while in debug mode
  // This is only to be used for confirming that reports are being
  // submitted as expected. It is not intended to be used for everyday
  // development.
  Crashlytics.instance.enableInDevMode = true;

  // Pass all uncaught errors from the framework to Crashlytics.
  FlutterError.onError = Crashlytics.instance.recordFlutterError;


  runApp(new MaterialApp(
    home: new MyApp(),
    navigatorObservers: <NavigatorObserver>[observer],
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
      navigateAfterSeconds: new RootPage(auth: new Auth(), analytics: analytics, observer: observer),
      imageBackground: new AssetImage('assets/images/splash.png'),
      loaderColor: Colors.deepOrange
    );
  }
}