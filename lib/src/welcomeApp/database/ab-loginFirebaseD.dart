import 'package:intl/intl.dart';
import 'package:portafolio/src/services/myInfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:portafolio/src/navigation.dart';

import 'package:portafolio/src/welcomeApp/pages/b-home.dart';

class WelcomeAppLoginFirebaseDatabase {

  FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future createUserFirestore({UserCredential myUser,String name}) async{
    String currentDate = DateTime.now().toString();
    String ddmmyy = '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}';
    String hour = DateFormat.jm().format(DateTime.now());

    MyInfo.myUserID = myUser.user.uid;


    //CREATE MY USER IN MESSAGES APP
    await _firestore
      .collection('MessagesAppUsers')
      .doc(myUser.user.uid)
      .set({
        'dateLastStory': currentDate,
        'email': myUser.user.email ?? 'telefono',
        'info': 'hola soy nuevo',
        'name': name,
        'online': true,
        'photoUrl': 'https://firebasestorage.googleapis.com/v0/b/to-home-1416d.appspot.com/o/profileImage%20(1).jpg?alt=media&token=6084b7da-e819-43b4-8fd0-b099f77c950b',
        'storiesSeenBy': ['.'],
        'friends': ['elonMusk'],
        'token': MyInfo.myToken
      });
    
    //CREATE MY FIRST STORIE
    await _firestore
      .collection('MessagesAppUsers')
      .doc(myUser.user.uid)
      .collection('stories')
      .add({
        'date': currentDate,        
        'imageUrl': 'https://firebasestorage.googleapis.com/v0/b/to-home-1416d.appspot.com/o/storie%20(1).jpg?alt=media&token=4f5e084c-cb20-4ad6-a4ca-74946c9023f0',
        'text': 'hola que tal'
      });
    
    //CREATE MY FRIEND
    await _firestore
      .collection('MessagesAppUsers')
      .doc(myUser.user.uid)
      .collection('friends')
      .doc('elonMusk')
      .set({
        'email': 'elonmusk@gmail.com',
        'info': 'me voy a marte',
        'photoUrl': 'https://www.cityam.com/wp-content/uploads/2021/01/Elon-Musk-Awarded-With-Axel-Springer-Award-In-Berlin-1229892421-960x668.jpg',
        'name': 'elon Musk'
      });
    
    //CREATE CONVERSATION WITH FRIEND
    await _firestore
      .collection('MessagesAppConversations')
      .add({
        'dateLastMessage': currentDate,
        'lastMessage': 'necesitamos tu talento en spaceX',
        'user1': 'elonMusk',
        'user1count': 1,        
        'user2': myUser.user.uid,
        'user2count': 1,
        'userss': ['elonMusk', myUser.user.uid],
        'writingUser1': false,
        'writingUser2': false,

      }).then((value) async{

        await _firestore
          .collection('MessagesAppUsers')
          .doc(myUser.user.uid)
          .collection('conversations')
          .doc('elonMusk')
          .set({
            'conversationID': value.id,
            'imUser1': false
          });
        
        await _firestore
          .collection('MessagesAppConversations')
          .doc(value.id)
          .collection('messages')
          .doc(currentDate)
          .set({
            'date': currentDate,
            'ddmmyy': ddmmyy,
            'featured1': false,
            'featured2': false,
            'hour': hour,
            'message': 'necesitamos tu talento en spaceX',
            'seen': 'not',
            'sentBy': 'elonMusk'
          });
      });
      

    //CREATE MY USER IN ECOMMERCE APP
    await _firestore
      .collection('EcommerceAppUsers')
      .doc(myUser.user.uid)
      .set({
        'name': name,
        'lastProductVisit': 'none'
      });
    

    //NAVIGATION
    Nav().toUntil(WelcomeAppHome());
    
  }


  void checkUserExists(UserCredential myUser,String name) async{
    
    MyInfo.myUserID = myUser.user.uid;
    
    DocumentSnapshot doc = await _firestore
      .collection('MessagesAppUsers')
      .doc(myUser.user.uid)
      .get();
    

    if(doc.exists != true){
      createUserFirestore(myUser: myUser, name: name);
    }

  }

}