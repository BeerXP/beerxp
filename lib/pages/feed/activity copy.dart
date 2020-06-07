import 'package:beerxp/models/activities.dart';
import 'package:beerxp/models/users.dart';
import 'package:beerxp/services/repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:timeline_list/timeline.dart';
import 'package:timeline_list/timeline_model.dart';

class ActivitiesScreen extends StatefulWidget {

  final DocumentReference documentReference;
  final User user;
  
  ActivitiesScreen({this.documentReference, this.user});

  @override
  _ActivitiesScreenState createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  FirebaseAnalytics analytics = FirebaseAnalytics();
  var _repository = Repository();

  User currentUser;
  List<Activities> activitiesList = List<Activities>();
  Future<List<DocumentSnapshot>> _future;

  @override
  void initState() {
    super.initState();
    analytics.setCurrentScreen(screenName: "Activities");
    fetchActivities();
  }

  @override
  void dispose() {
    super.dispose();
  }


  void fetchActivities() async {
    FirebaseUser currentUser = await _repository.getCurrentUser();

    User user = await _repository.fetchUserDetailsById(currentUser.uid);
    setState(() {
      this.currentUser = user;
    });

    _future = _repository.fetchActivities(currentUser);

    _future.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: new Color(0xffff9800),
        title: Text('Activities'),
      ),
      body: Scaffold(
          children: activitiesListWidget(),
        ));
  }

  Timeline activitiesListWidget() {
    return FutureBuilder(
      future: _future,
      builder: ((context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
                //shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: ((context, index) => listItem(
                      list: snapshot.data,
                      index: index,
                      currentUser: currentUser,
                    )));
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        } else {
          return ListView.builder(itemCount: 0, 
                      itemBuilder: ((context, index) => listItem(
                      list: snapshot.data,
                      index: index,
                      currentUser: currentUser,
                    )));
        }
      }),
    );
  }

  timelineModel(TimelinePosition position) => Timeline.builder(
      itemBuilder: timelineBuilder,
      itemCount: doodles.length,
      physics: position == TimelinePosition.Left
          ? ClampingScrollPhysics()
          : BouncingScrollPhysics(),
      position: position);

TimelineModel timelineBuilder(BuildContext context, int i) {
    final doodle = doodles[i];
    final textTheme = Theme.of(context).textTheme;

return FutureBuilder(future: _future, timelineModel)

    return TimelineModel(
        Card(
          margin: EdgeInsets.symmetric(vertical: 16.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.network(doodle.doodle),
                const SizedBox(
                  height: 8.0,
                ),
                Text(doodle.time, style: textTheme.caption),
                const SizedBox(
                  height: 8.0,
                ),
                Text(
                  doodle.name,
                  style: textTheme.title,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 8.0,
                ),
              ],
            ),
          ),
        ),
        position:
            i % 2 == 0 ? TimelineItemPosition.right : TimelineItemPosition.left,
        isFirst: i == 0,
        isLast: i == doodles.length,
        iconBackground: doodle.iconBackground,
        icon: doodle.icon);
  }

  TimelineModel listItem(
      {List<DocumentSnapshot> list, User currentUser, int index}) {
        return Timeline();
      }
      


  TimelineModel activitieItem(DocumentSnapshot snapshot) {
    return TimelineModel(Placeholder(),
          position: TimelineItemPosition.random,
          iconBackground: Colors.redAccent,
          icon: Icon(Icons.blur_circular));
  }
}