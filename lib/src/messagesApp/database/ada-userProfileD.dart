import 'package:portafolio/src/services/myInfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageAppUserProfileDataBase {

  //CURRENT USER-ID
  String myUserID = MyInfo.myUserID;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<bool> getFriendRequest(String otherUserID) async{
    
    bool sent;

    await _firestore
      .collection('MessagesAppUsers')
      .doc(otherUserID)
      .collection('friendRequest')
      .get().then((documents){

        documents.docs.forEach((doc) {
          if(doc.id == myUserID){
            sent = true;
          }
        });

      });

    return sent;  
  }


  void sendRequest(String otherUserID) async{

    DocumentSnapshot myUserInfo;

    //GET MY DATA
    await _firestore
      .collection('MessagesAppUsers')
      .doc(myUserID)
      .get().then((doc){ 
        myUserInfo = doc;
      });


    //CREATE REQUEST IN OTHER USER
    await _firestore
      .collection('MessagesAppUsers')
      .doc(otherUserID)
      .collection('friendRequest')
      .doc(myUserID)
      .set({
        'name': myUserInfo.data()['name'],
        'info': myUserInfo.data()['info'],
        'email': myUserInfo.data()['email'],
        'photoUrl': myUserInfo.data()['photoUrl'],   
        'token': myUserInfo.data()['token']
      });
  }


}