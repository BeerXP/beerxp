import 'package:beerxp/pages/drinkin/drinkin.dart';
import 'package:beerxp/pages/feed/activity.dart';
import 'package:beerxp/pages/feed/feed.dart';
import 'package:beerxp/pages/profile/profile.dart';
import 'package:beerxp/pages/search/search.dart';
import 'package:beerxp/services/authentication.dart';
import 'package:beerxp/utils/notification_handler.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.auth, this.userId, this.logoutCallback, this.analytics, this.observer})
      : super(key: key);

  final FirebaseAnalyticsObserver observer;
  final FirebaseAnalytics analytics;
  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _HomePageState(observer);
}

PageController pageController;

class _HomePageState extends State<HomePage> with RouteAware {
  
  _HomePageState(this.observer);

  final FirebaseAnalyticsObserver observer;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  //bool _isEmailVerified = false;

  int _page = 0;

  void navigationTapped(int page) {
    //Animating Page
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      this._page = page;
    });
  }

  @override
  void initState() {
    super.initState();
    pageController = new PageController();

    // widget.analytics.setCurrentScreen(screenName: "Home");

    new FirebaseNotifications().setUpFirebase();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    observer.subscribe(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    super.dispose();
    observer.unsubscribe(this);
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            body: new PageView(
              children: [
                new Container(
                  color: Colors.orange,
                  child: FeedScreen(),
                ),
                new Container(color: Colors.orange, 
                child: SearchScreen()
                ),
                new Container(
                  color: Colors.orange,
                  child: DrinkinScreen(),
                ),
                new Container(
                    color: Colors.orange, 
                    child: ActivitiesScreen()
                    ),
                new Container(
                    color: Colors.orange,
                    child: ProfileScreen()
                    ),
              ],
              controller: pageController,
              physics: new NeverScrollableScrollPhysics(),
              onPageChanged: onPageChanged,
            ),
            bottomNavigationBar: new CupertinoTabBar(
              activeColor: Colors.orange,
              items: <BottomNavigationBarItem>[
                new BottomNavigationBarItem(
                    icon: new Icon(Icons.home, color: (_page == 0) ? Colors.black : Colors.grey),
                    title: new Container(height: 0.0),
                    backgroundColor: Colors.white),
                new BottomNavigationBarItem(
                    icon: new Icon(Icons.search, color: (_page == 1) ? Colors.black : Colors.grey),
                    title: new Container(height: 0.0),
                    backgroundColor: Colors.white),
                new BottomNavigationBarItem(
                    icon: new Icon(Icons.add_circle, color: (_page == 2) ? Colors.black : Colors.grey),
                    title: new Container(height: 0.0),
                    backgroundColor: Colors.white),
                new BottomNavigationBarItem(
                    icon: new Icon(Icons.star, color: (_page == 3) ? Colors.black : Colors.grey),
                    title: new Container(height: 0.0),
                    backgroundColor: Colors.white),
                new BottomNavigationBarItem(
                    icon: new Icon(Icons.person, color: (_page == 4) ? Colors.black : Colors.grey),
                    title: new Container(height: 0.0),
                    backgroundColor: Colors.white),
              ],
              onTap: navigationTapped,
              currentIndex: _page,
            ),
          );
  }

  @override
  void didPush() {
    _sendCurrentTabToAnalytics();
  }

  @override
  void didPopNext() {
    _sendCurrentTabToAnalytics();
  }

  void _sendCurrentTabToAnalytics() {
    // observer.analytics.setCurrentScreen(
    //   screenName: 'Home/tab$pageController',
    // );
  }

}