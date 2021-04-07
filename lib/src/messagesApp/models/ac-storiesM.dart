import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portafolio/src/services/formatDate.dart';


class MyStoriesInfo {
  String dateLastStory;
  
  MyStoriesInfo(
    this.dateLastStory
  );

  MyStoriesInfo.fromDocSnapshot(DocumentSnapshot doc){ 
    dateLastStory = FormatDatee().formatPastDate(
      doc.data()['dateLastStory'], true
    );
  }
}


class FriendInfoStory {
  String friendID;
  String friendName;
  String friendPhotoUrl;
  String dateLastStory;
  List storiesSeenBy;

  FriendInfoStory(
    this.friendID,
    this.friendName,
    this.friendPhotoUrl,
    this.dateLastStory,
    this.storiesSeenBy
  );

  FriendInfoStory.fromDocSnapshot(DocumentSnapshot doc){
  
    friendID = doc.id;
    friendName = doc.data()['name'];
    friendPhotoUrl = doc.data()['photoUrl'];
    dateLastStory = FormatDatee().formatPastDate(
      doc.data()['dateLastStory'], true
    );
    storiesSeenBy = doc.data()['storiesSeenBy'];
  }
}


class StorieInfo {
  String imageUrl;
  String text;
  String date;

  StorieInfo(
    this.imageUrl,
    this.text,
    this.date
  );

  StorieInfo.fromDocSnapshot(DocumentSnapshot doc){
    imageUrl = doc.data()['imageUrl'];
    text = doc.data()['text'];
    date = FormatDatee().formatPastDate(
      doc.data()['date'], true
    );
  }
}