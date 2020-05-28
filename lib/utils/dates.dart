import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DatesUtils {

  static String daysAgo(Timestamp time) {
    var diff = DateTime.now().difference(time.toDate());

    if (diff.inSeconds < 60) {
      return "${diff.inSeconds}s atrás";
    } else if (diff.inMinutes < 60) {
      return "${diff.inMinutes}min atrás";
    } else if (diff.inHours < 24) {
      return "${diff.inHours}h atrás";
    } else if (diff.inDays < 31) {
      return "${diff.inDays}d atrás";
    }
    
    return new DateFormat.yMd('pt_BR').add_jm().format(time.toDate());
  }

}