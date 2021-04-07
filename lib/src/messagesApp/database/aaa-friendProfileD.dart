import 'package:portafolio/src/services/myInfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:portafolio/src/messagesApp/models/aaa-friendProfileM.dart';

class MessageAppFriendProfileDatabase {

  //CURRENT USER-ID
  String myUserID = MyInfo.myUserID;
  
  FirebaseFirestore _firestore = FirebaseFirestore.instance;  


  Future<List<FriendCommon>> getFriendsCommon(String friendID) async{

    List<FriendCommon> myFriends = [];
    List<FriendCommon> friendsOfMyFriends = [];

    List<FriendCommon> friendsInCommon = [];

    //GET MY FRIENDS
    await _firestore
      .collection('MessagesAppUsers')
      .doc(myUserID)
      .collection('friends')
      .get().then((documents){

        documents.docs.forEach((doc) {
          myFriends.add(FriendCommon.fromDocumentSnapshot(doc));
        });
      });

    //GET FRIENDS OF MY FRIEND
    await _firestore
      .collection('MessagesAppUsers')
      .doc(friendID)
      .collection('friends')
      .get().then((documents){

        documents.docs.forEach((doc) {
          friendsOfMyFriends.add(FriendCommon.fromDocumentSnapshot(doc));
        });
      });
    
    //SEARCH FOR MATCHES
    for(int i = 0; i < myFriends.length; i++){

      for(int z = 0; z < friendsOfMyFriends.length; z++){

        if(myFriends[i].friendID == friendsOfMyFriends[z].friendID){
          friendsInCommon.add(myFriends[i]);
        }
      }
    }
    
    return friendsInCommon;
  }


  Future<List<SharedFile>> getSharedFiles(String conversationID) async{

    List<SharedFile> sharedFiles = [];

    if(conversationID != ''){

      await _firestore
        .collection('MessagesAppConversations')
        .doc(conversationID)
        .collection('sharedFiles')
        .get().then((documents){
          
          documents.docs.forEach((doc) {
            sharedFiles.add(SharedFile.fromDocumentSnapshot(doc));
          });

        });

    }
    
    return sharedFiles;
  }


  Future<List<FeaturedMessage>> getFeaturedMessages({
                                String conversationID,
                                bool imUser1
                              }) async{
    
    String refFeaturedMessage = imUser1 == true ?
      'featuredMessages1'
      :
      'featuredMessages2';

    List<FeaturedMessage> featuredMessageList = [];

    if(conversationID != ''){

      await _firestore
        .collection('MessagesAppConversations')
        .doc(conversationID)
        .collection(refFeaturedMessage)
        .orderBy('date', descending: true)
        .get().then((documents){

          documents.docs.forEach((doc) {            
            featuredMessageList.add(FeaturedMessage.fromDocumentSnapshot(doc));
          });

        });
        
    }
    
    return featuredMessageList;
  }

}