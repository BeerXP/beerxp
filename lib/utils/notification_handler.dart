import 'dart:io';
import 'package:beerxp/services/repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseNotifications {

 FirebaseMessaging _firebaseMessaging;
 final Firestore _firestore = Firestore.instance;

//  final void Function(String) callback;

//  FirebaseNotifications(this.callback);

 void setUpFirebase() {
   _firebaseMessaging = FirebaseMessaging();
   firebaseCloudMessaging_Listeners();
 }

 Future<void> firebaseCloudMessaging_Listeners() async {
   if (Platform.isIOS) iOS_Permission();

  FirebaseUser currentUser = await Repository().getCurrentUser();

  _firebaseMessaging.setAutoInitEnabled(true);

   _firebaseMessaging.getToken().then((token) {
    //  _firebaseMessaging.subscribeToTopic(currentUser.uid);
     _firestore
        .collection("Users")
        .document(currentUser.uid)
        .setData({"token": token}, merge: true);
   });

   _firebaseMessaging.configure(
     onMessage: (Map<String, dynamic> message) async {
      print("on message $message");
      
     },
     onResume: (Map<String, dynamic> message) async {
      print("on resume $message");
     },
     onLaunch: (Map<String, dynamic> message) async {
      print("on lauch $message");
     },
   );
 }

 Future<void> iOS_Permission() async {
   _firebaseMessaging.requestNotificationPermissions(
       IosNotificationSettings(sound: true, badge: true, alert: true));
   _firebaseMessaging.onIosSettingsRegistered
       .listen((IosNotificationSettings settings) {
     print("Settings registered: $settings");
   });
 }
}