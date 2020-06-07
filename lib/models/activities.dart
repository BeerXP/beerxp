
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Activities {
  
  String type;
  Icon icon;
  String reference;
  FieldValue timeStamp;

  Activities({this.type, this.reference});

   Map toMap(Activities activity) {
    var data = Map<String, dynamic>();
    data['type'] = activity.type;
    data['reference'] = activity.reference;
    data['icon'] = activity.icon;
    data['timeStamp'] = activity.timeStamp;
    return data;
}

  Activities.fromMap(Map<String, dynamic> mapData) {
    this.type = mapData['type'];
    this.reference = mapData['reference'];
    this.icon = mapData['icon'];
    this.timeStamp = mapData['timeStamp'];
  }

}