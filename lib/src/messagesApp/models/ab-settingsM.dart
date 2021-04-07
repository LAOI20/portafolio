import 'package:cloud_firestore/cloud_firestore.dart';

class MyProfile {
  String name;
  String email;
  String info;
  String photoUrl;

  MyProfile(
    this.name,
    this.email,
    this.info,
    this.photoUrl
  );

  MyProfile.fromDocumentSnapshot(DocumentSnapshot doc){
    name = doc.data()['name'];
    email = doc.data()['email'];
    info = doc.data()['info'];
    photoUrl = doc.data()['photoUrl'];
  }
}