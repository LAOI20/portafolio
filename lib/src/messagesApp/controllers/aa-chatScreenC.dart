import 'dart:io';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/state_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:portafolio/src/services/APImodel.dart';
import 'package:portafolio/src/services/myInfo.dart';
import 'package:portafolio/src/services/pageVideoCall.dart';
import 'package:portafolio/src/services/pushNotifications.dart';

import 'package:portafolio/src/navigation.dart';

import 'package:portafolio/src/messagesApp/models/aa-chatScreenM.dart';

import 'package:portafolio/src/messagesApp/database/aa-chatScreenD.dart';

import 'package:portafolio/src/messagesApp/widgets/cupertino.dart';
import 'package:portafolio/src/widgets/alertMessage.dart';

import 'package:flutter/material.dart';


class MessageAppChatScreenController extends GetxController with SingleGetTickerProviderMixin{

  FriendREF friendREF = MyInfo.friendInfo;
  
  bool showLoadWidget = false;

//ANIMATIONS
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  AnimationController appBarContainerAC;
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


  FocusNode focoSendMessageTextfield = FocusNode();







  @override
  void onInit() {    
    super.onInit();    

    focoSendMessageTextfield.addListener(() {
      MessageAppChatScreenDataBase()
        .imWriting(
          friendREF.conversationID,
          friendREF.isUser1,
          focoSendMessageTextfield.hasFocus
        );
    });

  //ANIMATIONS
  //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    appBarContainerAC = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2)
    );
    appBarContainerAC.repeat();
  //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  }
  

  @override
  void onClose(){

    MyInfo.friendID = '';
    appBarContainerAC.dispose();
    focoSendMessageTextfield.dispose();
    sendMessagetextFieldController.dispose();

    super.onClose();
  }









//EVENTS TEXTFIELDS
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  TextEditingController sendMessagetextFieldController = TextEditingController();

  void changeTextField(){
    
    update(['iconTextField']);
  }


  void sendMessage(BuildContext context){
    String messagee = sendMessagetextFieldController.text;

    FocusScope.of(context).unfocus();
    
    if(friendREF.conversationID != 'not'){
      
      MessageAppChatScreenDataBase().sendMessage(
        message: sendMessagetextFieldController.text,
        conversationID: friendREF.conversationID,
        heIsUser1: friendREF.isUser1
      );      

    } else {
      MessageAppChatScreenDataBase().sendFirstMessage(
        sendMessagetextFieldController.text, 
        friendREF.id

      ).then((conversationID){
        
        friendREF.conversationID = conversationID;
        update(['messagesListContainer']);
        
      });
    }    
    
    sendMessagetextFieldController.clear();
    update(['sendMessageContainer']);

    PushNotications().sendNotificationMessage(
      to: friendREF.token,
      title: MyInfo.myName,
      body: messagee,
      data: {
        'click_action': "FLUTTER_NOTIFICATION_CLICK",
        'type': 'message',
        'conversationID': friendREF.conversationID,
        'friendID': MyInfo.myUserID,
        'friendToken': MyInfo.myToken,
        'isUser1': friendREF.isUser1 == true ? 'false': 'true',
        'name': MyInfo.myName,
        'info': MyInfo.myInfo,
        'photoUrl': MyInfo.myPhotoUrl
      }
    ); 

  }
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<





  
  
  
  void makeVideoCall() async{
    await Permission.camera.request();
    await Permission.microphone.request();
    
    showLoadWidget = true;
    update();

    APImodel().postHttp(
      'https://stripepaymentapi20.herokuapp.com/createTokenAgora',
      body: {
        "channelName": MyInfo.myUserID
      }

    ).then((res){

      Nav().to(PageVideoCall(
        friendToken: friendREF.token,
        channelName: MyInfo.myUserID,
        role: ClientRole.Broadcaster,
        token: res.body,
        iInitCall: true,
      ));

      showLoadWidget = false;
      update();

      PushNotications().sendNotificationVideoCall(
        to: friendREF.token,
        data: {
          "click_action": "FLUTTER_NOTIFICATION_CLICK",
          'type': 'videoCall',
          'title': "VIDEO LLAMADA",
          'body': "${MyInfo.myName}. Toca para aceptar",
          'userToken': MyInfo.myToken,
          'userName': MyInfo.myName,
          'userPhotoUrl': MyInfo.myPhotoUrl,
          'channelName': MyInfo.myUserID,
          'callToken': res.body
        }
      );

    });
  }






  //TAKE OR SELECT PHOTO AND SEND MESSAGE WITH PHOTO
  void showCupertinoActionsPhoto(BuildContext context){
    MessageAppCupertino().showCupertinoActions(
      context: context,
      onTapTakePhoto: () => takePhoto(context, false),
      onTapSelectPhoto: () => takePhoto(context, true),
    );
  }


  void takePhoto(BuildContext context,bool fromGallery) async{

    showLoadWidget = true;
    update();

    FirebaseStorage storage = FirebaseStorage.instance;

    try {      
      File fileImage;
      final image = await ImagePicker().getImage(
        source: fromGallery == true ?
          ImageSource.gallery
          :
          ImageSource.camera
      );
      fileImage = File(image.path);

      Nav().back();

      Reference reference = storage.ref().child(DateTime.now().toIso8601String());
      UploadTask uploadTask = reference.putFile(fileImage);

      await uploadTask.then((taskk) async{
        await taskk.ref.getDownloadURL().then((value){  

          if(friendREF.conversationID != 'not'){
      
            MessageAppChatScreenDataBase().sendMessage(
              message: value,
              conversationID: friendREF.conversationID,
              heIsUser1: friendREF.isUser1
            );

            MessageAppChatScreenDataBase().addImageToSharedFiles(
              value, friendREF.conversationID
            );

          } else {
            MessageAppChatScreenDataBase().sendFirstMessage(
              value, 
              friendREF.id

            ).then((conversationID){
              friendREF.conversationID = conversationID;
              
              MessageAppChatScreenDataBase().addImageToSharedFiles(
                value, friendREF.conversationID
              );

              update(['messagesListContainer']);                           
            });
          } 

        });
      });

      showLoadWidget = false;
      update();

      PushNotications().sendNotificationMessage(
        to: friendREF.token,
        title: MyInfo.myName,
        body: '📷',
        data: {
          "click_action": "FLUTTER_NOTIFICATION_CLICK",
          'type': 'message',
          'conversationID': friendREF.conversationID,
          'friendID': MyInfo.myUserID,
          'friendToken': MyInfo.myToken,
          'isUser1': friendREF.isUser1 == true ? 'false': 'true',
          'name': MyInfo.myName,
          'info': MyInfo.myInfo,
          'photoUrl': MyInfo.myPhotoUrl
        }
      );

    } catch (e) {
      print('ERRRRORRR $e');
      
    }

    showLoadWidget = false;
    update();

  }


  //ON-LONG-PRESS MESSAGE FOR ADD TO FEATURED MESSAGES
  void cupertinoActionAddFeaturedMessages({BuildContext context, Messageee message}){

    if(message.featured != true){
      MessageAppCupertino().showAddFeaturedMessage(
        context: context,
      
        onTapAddMessage: (){
          MessageAppChatScreenDataBase().addFeaturedMessage(
            conversationID: friendREF.conversationID,
            imUser1: !friendREF.isUser1,
            message: message
          );
          
          Nav().back();
          AlertMessage().alertaMensaje('Listo, mensaje agregado a destacados');
        }
      );
    }
  }



}