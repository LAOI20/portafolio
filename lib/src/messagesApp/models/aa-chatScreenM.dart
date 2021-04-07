import 'package:cloud_firestore/cloud_firestore.dart';


class Messageee {
  String messageID;
  String message;
  String seen;
  String sentBy;
  String date;
  String ddmmyy;
  String hour;
  bool featured;

  Messageee(
    this.messageID,
    this.message,
    this.seen,
    this.sentBy,
    this.date,
    this.ddmmyy,
    this.hour,
    this.featured,
  );

  Messageee.fromDocumentSnapshot(DocumentSnapshot doc, bool imUser1){
    messageID = doc.id;
    message = doc.data()['message'];
    seen = doc.data()['seen'];
    sentBy = doc.data()['sentBy'];
    date = doc.data()['date'];
    ddmmyy = doc.data()['ddmmyy'];
    hour = doc.data()['hour'];
    featured = imUser1 == true ?
      doc.data()['featured1']
      :
      doc.data()['featured2'];
  }

}