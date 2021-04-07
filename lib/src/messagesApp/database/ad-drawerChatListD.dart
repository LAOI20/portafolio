import 'package:portafolio/src/services/myInfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:portafolio/src/messagesApp/models/ad-drawerChatListM.dart';

class MessageAppDrawerChatListDatabase {

  //CURRENT USER-ID
  String myUserID = MyInfo.myUserID;
  
  FirebaseFirestore _firestore = FirebaseFirestore.instance;


  //GET FRIENDS REQUEST
  Future<List<UserInfo>> getFriendsRequest() async{
    
    List<UserInfo> myFriendsRequest = [];

    await _firestore
      .collection('MessagesAppUsers')
      .doc(myUserID)
      .collection('friendRequest')
      .get().then((documents){

        documents.docs.forEach((doc) {
          myFriendsRequest.add(UserInfo.fromDocumentSnapshot(doc));
        });

      });
    
    return myFriendsRequest;
  }

  //GET MY FRIENDS
  Future<List<UserInfo>> getMyFriends() async{

    List<UserInfo> myFriends = [];

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
    
    await Future.forEach(friendsIDS, (friendID) async{
      await _firestore
        .collection('MessagesAppUsers')
        .doc(friendID)
        .get().then((doc){
          myFriends.add(UserInfo.fromDocumentSnapshot(doc));
        });
    });
    
    return myFriends;
  }


  //GET OTHER USERS (ALL USERS WHO ARE NOT MY FRIENDS)
  Future<List<UserInfo>> getOtherUsers(List<UserInfo> friends) async{

    List<UserInfo> equalsResults = [];

    List<UserInfo> allUsers = [];

    await _firestore
      .collection('MessagesAppUsers')
      .get().then((documents){

        documents.docs.forEach((doc) {
          allUsers.add(UserInfo.fromDocumentSnapshot(doc));
        });

      });
    
    //GET EQUALS RESULTS FROM MY FRIENDS AND ALL USERS
    for(int i = 0; i < friends.length; i++){
      for(int z = 0; z < allUsers.length; z++){
        if(friends[i].id == allUsers[z].id){
          equalsResults.add(friends[i]);
        }
      }
    }

    //REMOVE ALL USERS EXCEPT THOSE WHO ARE NOT MY FRIENDS
    equalsResults.forEach((element) {
      allUsers.removeWhere((user) => user.id == element.id);
    });

    //REMOVE MY USER FROM ALL USERS
    allUsers.removeWhere((element) => element.id == myUserID);

    return allUsers;
  }


  Future acceptReques(UserInfo user) async{
    //ADD USER TO MY FRIENDS
    await _firestore
      .collection('MessagesAppUsers')
      .doc(myUserID)
      .collection('friends')
      .doc(user.id)
      .set({
        'name': user.name,
        'info': user.info,
        'email': user.email,
        'photoUrl': user.photoUrl,
      });
    
    await _firestore
      .collection('MessagesAppUsers')
      .doc(myUserID)
      .update({
        'friends': FieldValue.arrayUnion([user.id])
      });

    //ADD ME TO YOURS FRIENDS
    await _firestore
      .collection('MessagesAppUsers')
      .doc(user.id)
      .collection('friends')
      .doc(myUserID)
      .set({
        'name': user.name,
        'info': user.info,
        'email': user.email,
        'photoUrl': user.photoUrl,
      });
    
    await _firestore
      .collection('MessagesAppUsers')
      .doc(user.id)
      .update({
        'friends': FieldValue.arrayUnion([myUserID])
      });
    
    //DELETE USER OF MY LIST FRIENDS REQUEST
    await _firestore
      .collection('MessagesAppUsers')
      .doc(myUserID)
      .collection('friendRequest')
      .doc(user.id)
      .delete();        
      
  }

  //GET CONVERSATION ID OF FRIEND AND KNOW IF HE IS USER 1
  Future<Map<String, dynamic>> seeProfileFriend(String friendID) async{

    Map<String, dynamic> result = {
      'idConversation': '',
      'heIsUser1': null
    };

    await _firestore
      .collection('MessagesAppUsers')
      .doc(myUserID)
      .collection('conversations')
      .doc(friendID)
      .get().then((doc){
        if(doc.exists){
          result['idConversation'] = doc.data()['conversationID'];
        }
      });
    
    if(result['idConversation'] != ''){

      await _firestore
        .collection('MessagesAppConversations')
        .doc(result['idConversation'])
        .get().then((doc){
          if(doc.data()['user1'] == myUserID){
            result['heIsUser1'] = false;
          } else {
            result['heIsUser1'] = true;
          }
        });
        
    } else {
      result['idConversation'] = 'not';
    }

    return result;
  }


  Future<UserInfo> getUserQrScanner(String userID) async{
    UserInfo userInfo;

    await _firestore
      .collection('MessagesAppUsers')
      .doc(userID)
      .get().then((doc){
        userInfo = UserInfo.fromDocumentSnapshot(doc);
      });

    return userInfo;
  }

}