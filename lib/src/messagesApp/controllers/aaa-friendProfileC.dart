import 'package:portafolio/src/services/myInfo.dart';
import 'package:get/state_manager.dart';

import 'package:portafolio/src/navigation.dart';

import 'package:portafolio/src/messagesApp/models/aaa-friendProfileM.dart';

import 'package:portafolio/src/messagesApp/database/aaa-friendProfileD.dart';

import 'package:portafolio/src/messagesApp/pages/aa-chatScreen.dart';

import 'package:portafolio/src/messagesApp/widgets/bottomSheets.dart';

import 'package:flutter/cupertino.dart';

class MessageAppFriendProfileController extends GetxController {

  //FRIEND ID GET OF PREVIOUS PAGE (THE VALUE CHANGE BEFORE NAVIGATION TO THIS PAGE)
  FriendREF friendREF = MyInfo.friendInfo;   



//BOTTOM SHEETS
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<  

  bool loadedFriendsCommon;

  List<FriendCommon> friendsCommonResult = [];

  //SHOW BOTTOM SHEET WITH FRIENDS IN COMMON
  void seeFriendsCommon(BuildContext context){
    
    MessageAppBottomSheets().messageAppShowFriendsCommonOrMutimedia(
      context: context,
      title: 'Amigos en comun',
      showFriends: true
    );

    //TO CHARGE THEM ONLY ONCE
    if(loadedFriendsCommon != true){
      MessageAppFriendProfileDatabase().getFriendsCommon(friendREF.id)
        .then((valueList){
          friendsCommonResult = valueList;
          loadedFriendsCommon = true;
          update(['FriendsOrFilesBottomSheet']);
        });
        
    }
  }



  bool loadedSharedFiles;

  List<SharedFile> shareddFiless = [];

  void seeSharedFiles(BuildContext context){

    MessageAppBottomSheets().messageAppShowFriendsCommonOrMutimedia(
      context: context, 
      title: 'Multimedia',
      showFriends: false
    );  
    
    //TO CHARGE THEM ONLY ONCE
    if(loadedSharedFiles != true){
      
      MessageAppFriendProfileDatabase().getSharedFiles(friendREF.conversationID)
        .then((valueList){
          shareddFiless = valueList;
          loadedSharedFiles = true;
          update(['FriendsOrFilesBottomSheet']);
        });
    }

  }


  bool loadedFeaturedMessages;

  List<FeaturedMessage> featuredMessagesList = [];

  void seeFeaturedMessages(BuildContext context){
    
    MessageAppBottomSheets().messageAppShowFeaturedMessages(context);

    //TO CHARGE THEM ONLY ONCE
    if(loadedFeaturedMessages != true){

      MessageAppFriendProfileDatabase().getFeaturedMessages(
        conversationID: friendREF.conversationID,
        imUser1: friendREF.isUser1 == true ? false : true
        
      ).then((valueList){
          featuredMessagesList = valueList;
          loadedFeaturedMessages = true;
          update(['FeaturedMessagesBottomSheet']);
        });

    }

  }
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<







  //WRITE MESSAGE TO FRIEND
  void onTapWriteMessage(){
    MyInfo.friendInfo.conversationID = friendREF.conversationID;

    Nav().back();
    Nav().back();
    Nav().to(MessageAppChatScreen());
  }



}