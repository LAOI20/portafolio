import 'package:portafolio/src/services/myInfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'package:portafolio/src/messagesApp/models/aa-chatScreenM.dart';

class MessageAppChatScreenDataBase {

  //CURRENT USER-ID
  String myUserID = MyInfo.myUserID;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;   


  Stream<List<Messageee>> messagesListStream(String conversationID,bool friendIsUser1){
    return _firestore
      .collection('MessagesAppConversations')
      .doc(conversationID)
      .collection('messages')
      .orderBy('date')
      .snapshots()
      .map((query){
        List<Messageee> messages = [];
        String countMessagesREF = friendIsUser1 == true ?
          'user1count' : 'user2count';

        query.docs.forEach((document) {  
          //CHECK SEEN MESSAGES
          if(document.data()['seen'] == 'not' &&
             document.data()['sentBy'] != myUserID
          ){
            document.reference.update({
              'seen': DateTime.now().toString()
            });

            //MESSAGE COUNTER TO 0
            document.reference.parent.parent.update({
              countMessagesREF: 0
            });
          }

          if(friendIsUser1 == true){
            messages.add(Messageee.fromDocumentSnapshot(document, false));
          } else {
            messages.add(Messageee.fromDocumentSnapshot(document, true));
          }
        });

        return messages;
      });
  }

  Stream<List<bool>> getStatusFriend(String friendID){
    return _firestore
      .collection('MessagesAppUsers')
      .doc(friendID)
      .snapshots()
      .map((doc){
        List<bool> onlineYwriting = [false, false];
        onlineYwriting[0] = doc.data()['online'];
        onlineYwriting[1] = doc.data()['writing'];

        return onlineYwriting;
      });
  }

  //WHEN TEXTFIELD IS SELECT
  void imWriting(String conversationID,bool friendIsUser1,bool writing){
    String field = friendIsUser1 == true ? 'writingUser2' : 'writingUser1';

    _firestore
      .collection('MessagesAppConversations')
      .doc(conversationID)
      .update({
        field: writing
      });
  }


  void sendMessage({String message,String conversationID,bool heIsUser1}) {
    try { 
      
      String fecha = DateTime.now().toString();
      String date = '${DateTime.parse(fecha).year}-${DateTime.parse(fecha).month}-${DateTime.parse(fecha).day}';
      String hour = DateFormat.jm().format(DateTime.parse(fecha));

      //ADD MESSAGE TO MY CONVERSATION
      _firestore
      .collection('MessagesAppConversations')
      .doc(conversationID)
      .collection('messages')
      .doc(fecha)
      .set({
        'message': message,
        'sentBy': myUserID,
        'date': fecha,
        'ddmmyy': date,
        'hour': hour,
        'seen': 'not',
        'featured': false
      });

      //CHANGE LAST MESSAGE AND COUNT IN CONVERSATION
      _firestore
      .collection('MessagesAppConversations')
      .doc(conversationID)
      .update({
        'dateLastMessage': fecha,
        'lastMessage': message,
        'user1count': heIsUser1 == true ? 0 : FieldValue.increment(1),
        'user2count': heIsUser1 == true ? FieldValue.increment(1) : 0
      });


    } catch (e) {
      print(e);
      rethrow;
    }
  }


  //CREATE A NEW CONVERSATION WITH FRIEND
  Future<String> sendFirstMessage(String message,String idFriend) async{ 

    String fecha = DateTime.now().toString();
    String date = '${DateTime.parse(fecha).year}-${DateTime.parse(fecha).month}-${DateTime.parse(fecha).day}';
    String hour = DateFormat.jm().format(DateTime.parse(fecha));
      
    DocumentReference docConversation = await _firestore
      .collection('MessagesAppConversations')
      .add({
        'dateLastMessage': fecha,
        'lastMessage': message,
        'user1': myUserID,
        'user1count': 0,
        'user2': idFriend,
        'user2count': 1,
        'userss': [myUserID, idFriend]
      });
    
    //CREATE MESSAGE
    await _firestore
      .collection('MessagesAppConversations')
      .doc(docConversation.id)
      .collection('messages')
      .doc(fecha)
      .set({
        'date': fecha,
        'ddmmyy': date,
        'featured': false,
        'hour': hour,
        'message': message,
        'seen': 'not',
        'sentBy': myUserID
      });

    //CREATE CONVERSATION IN MY USER INFO
    await _firestore
      .collection('MessagesAppUsers')
      .doc(myUserID)
      .collection('conversations')
      .doc(idFriend)
      .set({
        'conversationID': docConversation.id,
        'imUser1': true
      });

    //CREATE CONVERSATION IN INFO OF FRIEND
    await _firestore
      .collection('MessagesAppUsers')
      .doc(idFriend)
      .collection('conversations')
      .doc(myUserID)
      .set({
        'conversationID': docConversation.id,
        'imUser1': false
      });    

    return docConversation.id;
  }


  void addFeaturedMessage({String conversationID,bool imUser1,Messageee message}){
    try {
      
      String refFeaturedMjs = imUser1 == true ? 
        'featuredMessages1' 
        : 
        'featuredMessages2';
      
      String changeMessage = imUser1 == true ?
        'featured1'
        :
        'featured2';

      //CHANGE MESSAGE IN CONVERSATION TO FEATURED MESSAGE
      _firestore
        .collection('MessagesAppConversations')
        .doc(conversationID)
        .collection('messages')
        .doc(message.messageID)
        .update({
          changeMessage: true
        });

      //ADD MESSAGE TO MESSAGES FEATURED LIST
      _firestore
        .collection('MessagesAppConversations')
        .doc(conversationID)
        .collection(refFeaturedMjs)
        .add({
          'message': message.message,
          'date': message.date,
          'sentBy': message.sentBy
        });

    } catch (e) {
      print(e);
      rethrow;
    }
  }


  Future addImageToSharedFiles(String imageUrl,String conversationID) async{
    
    String fecha = DateTime.now().toString();
    String date = '${DateTime.parse(fecha).day}-${DateTime.parse(fecha).month}-${DateTime.parse(fecha).year}';
    String hour = DateFormat.jm().format(DateTime.parse(fecha));

    await _firestore
      .collection('MessagesAppConversations')
      .doc(conversationID)
      .collection('sharedFiles')
      .add({
        'imageUrl': imageUrl,
        'date': fecha,
        'dateFormat': date,
        'hour': hour
      });
  }


}