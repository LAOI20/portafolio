import 'package:get/state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:portafolio/src/services/myInfo.dart';

import 'package:portafolio/src/navigation.dart';

import 'package:portafolio/src/messagesApp/controllers/ad-drawerChatListC.dart';

import 'package:portafolio/src/messagesApp/models/a-chatListM.dart';

import 'package:portafolio/src/messagesApp/database/a-chatListD.dart';

import 'package:portafolio/src/messagesApp/pages/aa-chatScreen.dart';

import 'package:flutter/material.dart';

class MessageAppChatListController extends GetxController with SingleGetTickerProviderMixin{


  //USE IN TEXT FIELD OF APP BAR CONTAINER
  FocusNode foco = FocusNode();

  //USE FOR ANIMATE STORIES CONTAINER
  AnimationController storiesContainerAC;


//DATABASE STREAMS
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  
  //GET ALL CONVERSATIONS
  Stream<List<ViewConversation>> conversationsStream = MessageAppChatListDatabase().conversationsStream();

  //GET STATUS ONLINE OF FRIEND
  Stream<SimpleUser> streamfriendOnline(String friendID){
    return MessageAppChatListDatabase().friendOnlineStream(friendID);
  }

//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  

  @override
  void onInit() {
    super.onInit(); 

  //ANIMATIONS
  //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    foco.addListener(() {
      print(foco.hasFocus);
    });

    storiesContainerAC = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 900)
    );
    storiesContainerAC.repeat(reverse: true);
  //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  }  

  @override
  void onClose() {  
    
    foco.dispose();
    storiesContainerAC.dispose();

    Get.delete<MessageAppDrawerChatListController>();

    super.onClose();
  }



//NAVIGATION
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  //NAVIGATION TO PAGE CHAT
  void navigationToChatFriend(BuildContext context,
                              ViewConversation conversation,
                              SimpleUser infoFriend
                            ){  
    
    MyInfo.friendInfo = FriendREF.fromData(
      idConversation: conversation.conversationID,
      friendID: conversation.friendID, 
      friendToken: infoFriend.token,
      heIsUser1: conversation.imUser1 == true ? false : true,        
      friendName: infoFriend.name,
      infoFriend: infoFriend.info,
      urlPhoto: infoFriend.photoUrl
    );

    MyInfo.friendID = conversation.friendID;
    
    Nav().to(MessageAppChatScreen());
  }
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<



}
