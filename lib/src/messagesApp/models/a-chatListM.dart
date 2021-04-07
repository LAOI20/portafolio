import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portafolio/src/services/formatDate.dart';

class ViewConversation {
  String conversationID;
  bool imUser1;
  String friendID;
  String lastMessage;
  String dateLastMessage;
  int countLastMessages;
  bool writingFriend;

  ViewConversation(
    this.conversationID,
    this.imUser1,
    this.friendID,
    this.lastMessage,
    this.dateLastMessage,
    this.countLastMessages,
    this.writingFriend
  );

  ViewConversation.fromDocumentSnapshot(DocumentSnapshot doc,bool amIuser1){
    conversationID = doc.id;
    imUser1 = amIuser1;

    friendID = amIuser1 == true ? 
      doc.data()['user2'] 
      : 
      doc.data()['user1'];    
    
    lastMessage = doc.data()['lastMessage'];
    dateLastMessage = FormatDatee().formatPastDate(
      doc.data()['dateLastMessage'], true
    );

    countLastMessages = amIuser1 == true ? 
      doc.data()['user2count'] 
      : 
      doc.data()['user1count'];
    
    writingFriend = amIuser1 == true ?
      doc.data()['writingUser2']
      :
      doc.data()['writingUser1'];
  }

}


class SimpleUser {
  String name;
  String info;
  String photoUrl;
  String token;
  bool online;

  SimpleUser(
    this.name,
    this.info,
    this.photoUrl,
    this.token,
    this.online,
  );

  SimpleUser.fromDocumentSnapshot(DocumentSnapshot doc){
    name = doc.data()['name'];
    info = doc.data()['info'];
    photoUrl = doc.data()['photoUrl'];
    token = doc.data()['token'];
    online = doc.data()['online'];
  }
}