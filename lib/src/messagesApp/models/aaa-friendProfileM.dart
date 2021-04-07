import 'package:cloud_firestore/cloud_firestore.dart';

class FriendCommon {
  String friendID;
  String name;
  String info;
  String photoUrl;

  FriendCommon(
    this.friendID,
    this.name,
    this.info,
    this.photoUrl
  );

  FriendCommon.fromDocumentSnapshot(DocumentSnapshot doc){
    friendID = doc.id;
    name = doc.data()['name'];
    info = doc.data()['info'];
    photoUrl = doc.data()['photoUrl'];
  }
}


class SharedFile {
  String path;
  String date;

  SharedFile(
    this.path,
    this.date
  );

  SharedFile.fromDocumentSnapshot(DocumentSnapshot doc){
    path = doc.data()['imageUrl'];
    date = doc.data()['dateFormat'];
  }
}


class FeaturedMessage {
  String message;
  String date;
  String sentBy;

  FeaturedMessage(
    this.message,
    this.date,
    this.sentBy
  );

  FeaturedMessage.fromDocumentSnapshot(DocumentSnapshot doc){
    message = doc.data()['message'];
    date = doc.data()['date'];
    sentBy = doc.data()['sentBy'];
  }
}