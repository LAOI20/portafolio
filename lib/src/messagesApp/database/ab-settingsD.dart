import 'package:portafolio/src/services/myInfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:portafolio/src/messagesApp/models/ab-settingsM.dart';

class MessageAppSettingsDatabase {

  //CURRENT USER-ID
  String myUserID = MyInfo.myUserID;
  
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;


  //GET MY DATA
  Future<MyProfile> getUserData() async{

    MyProfile myProfile;

    print(myUserID);
    await _firestore
      .collection('MessagesAppUsers')
      .doc(myUserID)
      .get().then((doc){        
        myProfile = MyProfile.fromDocumentSnapshot(doc);
      });
    
    return myProfile;
  }


  //CHANGE MY NAME OR INFO
  Future changeMyNameOrInfo(String newName,String newInfo) async{

    await _firestore
      .collection('MessagesAppUsers')
      .doc(myUserID)
      .update({
        'name': newName,
        'info': newInfo
      });
  }

  Future<String> updateMyPhoto(bool fromGallery) async{
    String photoUrl;

    try {      
      File fileImage;
      final image = await ImagePicker().getImage(
        source: fromGallery == true ? 
          ImageSource.gallery
          :
          ImageSource.camera
      );
      fileImage = File(image.path);

      Reference reference = storage.ref().child(MyInfo.myUserID);
      UploadTask uploadTask = reference.putFile(fileImage);

      await uploadTask.then((taskk) async{
        await taskk.ref.getDownloadURL().then((value) async{
          await _firestore
            .collection('MessagesAppUsers')
            .doc(myUserID)
            .update({
              'photoUrl': value
            });
          
          photoUrl = value;
        });
      });

    } catch (e) {
      print('ERRRRORRR $e');
      
    }

    return photoUrl;
    
  }

  
}