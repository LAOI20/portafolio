import 'package:cloud_firestore/cloud_firestore.dart';

//ALSO USED IN PAGE AC-STORIES

class UserInfo {
  String id;
  String name;
  String info;
  String email;
  String photoUrl;
  String token;

  UserInfo(
    this.id,
    this.name,
    this.info,
    this.email,
    this.photoUrl,
    this.token
  );

  UserInfo.fromDocumentSnapshot(DocumentSnapshot doc){
    id = doc.id;
    name = doc.data()['name'];
    info = doc.data()['info'];
    email = doc.data()['email'];
    photoUrl = doc.data()['photoUrl'];
    token = doc.data()['token'];
  }

}