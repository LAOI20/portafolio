import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:portafolio/src/services/myInfo.dart';

import 'package:portafolio/src/messagesApp/models/ac-storiesM.dart';


class MessageAppStoriesDatabase {

  String myUserID = MyInfo.myUserID;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<List<String>> getMyFriends() async{
    List<String> friendsIDS = [];

    await _firestore
      .collection('MessagesAppUsers')
      .doc(myUserID)
      .collection('friends')
      .get().then((documents){
        documents.docs.forEach((doc) {
          friendsIDS.add(doc.id);
        });
      });

    return friendsIDS;
  }


  Stream<MyStoriesInfo> streamMyStoriesInfo(){
    return _firestore
      .collection('MessagesAppUsers')
      .doc(myUserID)
      .snapshots()
      .map((doc){
        MyStoriesInfo myStories;

        myStories = MyStoriesInfo.fromDocSnapshot(doc);

        return myStories;
      });
  }


  Stream<List<FriendInfoStory>> streamFriendsInfoStories(){
    return _firestore
      .collection('MessagesAppUsers')
      .where('friends', arrayContains: myUserID)
      .orderBy('dateLastStory', descending: true)
      .snapshots()
      .map((query){
        List<FriendInfoStory> friendsInfoStory = [];
        
        query.docs.forEach((doc) {
          friendsInfoStory.add(FriendInfoStory.fromDocSnapshot(doc));          
        });
    
        return friendsInfoStory;
      });
  }


  Future addToMyStories(File fileImage,String text) async{
    FirebaseStorage storage = FirebaseStorage.instance;

    String date = DateTime.now().toString();

    Reference reference = storage.ref().child(date);
    UploadTask uploadTask = reference.putFile(fileImage);

    await uploadTask.then((taskk) async{
      await taskk.ref.getDownloadURL().then((value) async{  

        await _firestore
          .collection('MessagesAppUsers')
          .doc(myUserID)
          .collection('stories')
          .add({
            'date': date,
            'imageUrl': value,
            'text': text
          });
      
        await _firestore
          .collection('MessagesAppUsers')
          .doc(myUserID)
          .update({
            'storiesSeenBy': ['.']
          });

      });
    });

  }


  Future<List<StorieInfo>> getStories(String friendID) async{
    List<StorieInfo> stories = [];

    await _firestore
      .collection('MessagesAppUsers')
      .doc(friendID)
      .collection('stories')
      .orderBy('date',)
      .get().then((documents){
        documents.docs.forEach((doc) {
          stories.add(StorieInfo.fromDocSnapshot(doc));
        });
      });
    
    return stories;
  }


  void seeFriendStories(FriendInfoStory friendInfoStory) async{
    bool storySeen;

    //CHECK IF I SAW THE STORY
    await Future.forEach(friendInfoStory.storiesSeenBy, (element){
      if(element == myUserID){
        storySeen = true;
      }
    });

    if(storySeen != true){
      _firestore
        .collection('MessagesAppUsers')
        .doc(friendInfoStory.friendID)
        .update({
          'storiesSeenBy': FieldValue.arrayUnion([myUserID])
        });
    }

  }

}