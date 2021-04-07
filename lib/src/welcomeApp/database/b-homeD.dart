import 'package:portafolio/src/services/myInfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WelcomeAppHomeDatabase {

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  
  void getMyData(){
    _firestore
      .collection('MessagesAppUsers')
      .doc(MyInfo.myUserID)
      .get().then((doc){
        MyInfo.myName = doc.data()['name'];
        MyInfo.myInfo = doc.data()['info'];
        MyInfo.myEmail = doc.data()['email'];
        MyInfo.myPhotoUrl = doc.data()['photoUrl'];
      });
  }


  void updateStatus(bool isOnline){
    _firestore
      .collection('MessagesAppUsers')
      .doc(MyInfo.myUserID)
      .update({
        'online': isOnline
      });
  }

  void updateMyToken(){
    _firestore
      .collection('MessagesAppUsers')
      .doc(MyInfo.myUserID)
      .update({
        'token': MyInfo.myToken
      });
  }

}