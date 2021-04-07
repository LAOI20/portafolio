import 'package:portafolio/src/services/myInfo.dart';
import 'package:portafolio/src/services/pushNotifications.dart';
import 'package:get/state_manager.dart';

import 'package:portafolio/src/navigation.dart';

import 'package:portafolio/src/messagesApp/controllers/ada-userProfileC.dart';

import 'package:portafolio/src/messagesApp/models/ad-drawerChatListM.dart';

import 'package:portafolio/src/messagesApp/database/ad-drawerChatListD.dart';

import 'package:portafolio/src/messagesApp/pages/aaa-friendProfile.dart';
import 'package:portafolio/src/messagesApp/pages/ada-userProfile.dart';

import 'package:portafolio/src/widgets/alertMessage.dart';

import 'package:flutter/material.dart';


class MessageAppDrawerChatListController extends GetxController {

  List<UserInfo> myFriends = [];

  //USERS WHO ARE NOT MY FRIENDS
  List<UserInfo> userss = [];

  List<UserInfo> friendsRequest = [];


  int indexPage = 0;  


  void onTapChangeView(int pageIndx){
    indexPage = pageIndx;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    
    MessageAppDrawerChatListDatabase().getMyFriends()
      .then((myFriendsList){

        myFriends = myFriendsList;

        MessageAppDrawerChatListDatabase().getFriendsRequest()
          .then((requestList){

            friendsRequest = requestList;

          }).then((value){

            MessageAppDrawerChatListDatabase().getOtherUsers(myFriendsList)
              .then((otherUsers){

                userss = otherUsers;

                update();
              });

          });
      });
  }


  @override
  void onClose(){
    MyInfo.friendID = '';

    super.onClose();
  }


  

//EVENTS TEXTFIELS
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  TextEditingController searchUserController = TextEditingController();

  void onChangeSearchTextField(){
    update(['SearchUsers']);
  }

//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<











  //NAVIGATION FOR SEE USER PROFILE
  void seeUserProfile(UserInfo user){
    MessageAppUserProfileController.userInfoo = user;

    Nav().to(MessageAppUserProfile());
  }


  void qrScanSeeProfile(String userID){

    bool isMyFriend;

    MessageAppDrawerChatListDatabase().getUserQrScanner(userID)
      .then((useer){
        print(useer.id);
        if(useer.id != null){

          //CHECK IF USER IS MY FRIEND
          Future.forEach(myFriends, (UserInfo friend){            
            if(friend.id == userID){
              isMyFriend = true;
            }
          }).then((value){

            if(isMyFriend == true){
              Nav().back();
              seeFriendProfile(useer);
            } else {
              Nav().back();
              seeUserProfile(useer);
            }

          });

        }
      });
  
  }


  //SEE PROFILE OF MY FRIEND
  void seeFriendProfile(UserInfo refFriend){
    MessageAppDrawerChatListDatabase().seeProfileFriend(refFriend.id)
      .then((result){
        
        MyInfo.friendInfo = FriendREF.fromData(
          idConversation: result['idConversation'],
          friendID: refFriend.id,
          friendToken: refFriend.token,
          heIsUser1: result['heIsUser1'],
          friendName: refFriend.name,
          infoFriend: refFriend.info,
          urlPhoto: refFriend.photoUrl
        );

        MyInfo.friendID = refFriend.id;
        
        Nav().to(MessageAppFriendProfile(writeMessage: true));
      });

  }


  //FOR ACCEPT REQUEST OF SOME USER
  void acceptRequest(UserInfo infoUser){

    AlertMessage().alertaMensaje('Solicitud aceptada\n${infoUser.name} y tu\nahora son amigos');

    MessageAppDrawerChatListDatabase().acceptReques(infoUser)
      .then((value){
        //REMOVE OF ALL USERS WHOT ARE NOT MY FRIENDS
        userss.removeWhere((element) => element.id == infoUser.id);

        //REMOVE OF MY FRIENDS REQUEST
        friendsRequest.removeWhere((element) => element.id == infoUser.id);
        
        //ADD USER TO MY FRIENDS
        myFriends.add(infoUser);

        update();

        PushNotications().sendNotificationMessage(
          to: infoUser.token,
          title: 'Solicitud Aceptada',
          body: '${MyInfo.myName} y tu ahora son amigos',
          data: {
            "click_action": "FLUTTER_NOTIFICATION_CLICK",
            'type': 'AcceptRequest',
            'friendID': MyInfo.myUserID,
            'friendToken': MyInfo.myToken,
            'friendName': MyInfo.myName,
            'friendInfo': MyInfo.myInfo,
            'friendEmail': MyInfo.myEmail,
            'friendPhotoUrl': MyInfo.myPhotoUrl,
          }
        ); 

      });
  }


}