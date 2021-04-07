import 'package:portafolio/src/services/myInfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:portafolio/src/messagesApp/models/a-chatListM.dart';

class MessageAppChatListDatabase {

  //CURRENT USER-ID
  String myUserID = MyInfo.myUserID;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
 


  Stream<List<ViewConversation>> conversationsStream(){
    return _firestore
      .collection('MessagesAppConversations')
      .where('userss', arrayContains: myUserID)
      .orderBy('dateLastMessage', descending: true)
      .snapshots()
      .map((query){
        List<ViewConversation> conversations = [];

        query.docs.forEach((doc) { 
          if(doc.data()['user1'] == myUserID){
            conversations.add(ViewConversation.fromDocumentSnapshot(doc, true));
          } else {
            conversations.add(ViewConversation.fromDocumentSnapshot(doc, false));
          }
        });

        return conversations;
      });
  }

  Stream<SimpleUser> friendOnlineStream(String friendID){
    return _firestore
      .collection('MessagesAppUsers')
      .doc(friendID)
      .snapshots()
      .map((doc){
        
        SimpleUser user;

        user = SimpleUser.fromDocumentSnapshot(doc);

        return user;
      });
  }

}