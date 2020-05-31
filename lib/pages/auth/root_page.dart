import 'package:beerxp/login/login_page.dart';
import 'package:beerxp/main.dart';
import 'package:beerxp/pages/auth/home_page.dart';
import 'package:beerxp/services/authentication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class RootPage extends StatefulWidget {
  RootPage({this.auth, this.analytics, this.observer});

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

class _RootPageState extends State<RootPage> {
  FirebasePerformance _performance = FirebasePerformance.instance;
  Crashlytics _crashlytics = Crashlytics.instance;

  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "";

  @override
  void initState() {
    super.initState();
    
    // Habilita uso offline
    Firestore.instance.settings(persistenceEnabled: true);

    //Inicia o Ana;ytics informando abertura do APP
    _initAnalytics();

    //Inicia coleta de dados de performance
    _initPerformance();

    //Configura o Crashlytics
    _initCrashlytics();


    initializeDateFormatting();

    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          _userId = user?.uid;
        }
        authStatus =
            user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
  }

  void _initAnalytics() async {
    widget.analytics.setAnalyticsCollectionEnabled(true);
    widget.analytics.logAppOpen();
  }

  void _initPerformance() async {
    _performance.setPerformanceCollectionEnabled(true);
  }

  void _initCrashlytics() async {
    _crashlytics.enableInDevMode = true;
  }


  void loginCallback() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        _userId = user.uid.toString();
      });
    });
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;
    });
  }

  void logoutCallback() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
    });
  }

  Widget buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return buildWaitingScreen();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        return new LoginPage(
            auth: widget.auth,
            loginCallback: loginCallback,
            analytics: analytics,
            observer: observer,
        );
        break;
      case AuthStatus.LOGGED_IN:
        if (_userId.length > 0 && _userId != null) {
          analytics.setUserId(_userId);
          return new HomePage(
            userId: _userId,
            auth: widget.auth,
            logoutCallback: logoutCallback,
            analytics: widget.analytics,
            observer: widget.observer,
          );
        } else
          return buildWaitingScreen();
        break;
      default:
        return buildWaitingScreen();
    }
  }
}