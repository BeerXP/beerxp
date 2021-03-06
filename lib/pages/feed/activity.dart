import 'package:beerxp/models/users.dart';
import 'package:beerxp/services/repository.dart';
import 'package:beerxp/utils/dates.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: new Color(0xffff9800),
        title: Text('Activities'),
      ),
      body: activitiesListWidget());
  }

  Widget activitiesListWidget() {
    return FutureBuilder(
      future: _future,
      builder: ((context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Timeline.builder(
                    itemBuilder: ((context, index) => timelineBuilder(context: context, index: index, list: snapshot.data)),
                    itemCount: snapshot.data.length,
                    physics: ClampingScrollPhysics(),
                    position: TimelinePosition.Left);
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        } else {
          return Timeline.builder(
                    itemBuilder: ((context, index) => timelineBuilder(context: context, index: index, list: snapshot.data)),
                    itemCount: 0,
                    physics: ClampingScrollPhysics(),
                    position: TimelinePosition.Left);
        }
      }),
    );
  }

  TimelineModel timelineBuilder({BuildContext context, int index, List<DocumentSnapshot> list}) {
    final activity = list[index];
    final textTheme = Theme.of(context).textTheme;

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
                Image.network(activity.data["imgUrl"], height: 150, width: 150),
                const SizedBox(
                  height: 8.0,
                ),
                Text(DatesUtils.timestampToFormat(activity.data["timeStamp"]), style: textTheme.caption),
                const SizedBox(
                  height: 8.0,
                ),
                Text(
                  "Teste",
                  style: textTheme.headline6,
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
            index % 2 == 0 ? TimelineItemPosition.right : TimelineItemPosition.left,
        isFirst: index == 0,
        isLast: index == list.length,
        // iconBackground: activitie.iconBackground,
        icon: (
                activity.data["type"] == "drinkin" ? Icon(FontAwesomeIcons.beer, color: Colors.orange) : 
              ( activity.data["type"] == "like" ? Icon(Icons.favorite, color: Colors.red) : 
              ( activity.data["type"] == "comment" ? Icon(Icons.comment, color: Colors.indigo) : Icon(Icons.star, color: Colors.yellow))
        )));
  }
}