import 'dart:ui';
import 'package:portafolio/src/services/myInfo.dart';
import 'package:get/state_manager.dart';

import 'package:portafolio/src/navigation.dart';

import 'package:portafolio/src/messagesApp/controllers/ad-drawerChatListC.dart';

import 'package:portafolio/src/messagesApp/models/ad-drawerChatListM.dart';

import 'package:portafolio/src/messagesApp/pages/ab-settings.dart';
import 'package:portafolio/src/messagesApp/pages/adb-scanQrCode.dart';

import 'package:portafolio/src/messagesApp/widgets/alertDialogs.dart';
import 'package:portafolio/src/widgets/buttons.dart';
import 'package:portafolio/src/widgets/imagee.dart';
import 'package:portafolio/src/widgets/loadings.dart';
import 'package:portafolio/src/widgets/textfield.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageAppDrawerChatList extends StatelessWidget {
  const MessageAppDrawerChatList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {      
    return GetBuilder<MessageAppDrawerChatListController>(
      init: MessageAppDrawerChatListController(),
      builder: (_) {

        List pages = [
          _Menu(
            onTapSearchUser: () => _.onTapChangeView(1),
            onTapShowFriends: () => _.onTapChangeView(2),
            onTapShowRequest: () => _.onTapChangeView(3)
          ),
          _SearchUsers(),
          _ShowMyFriends(),
          _ShowRequest()
        ];

        return GestureDetector(
          onTap: (){ 
            if(_.indexPage == 0){
              Nav().back(); 
            }
          },

          child: Scaffold(
            backgroundColor: Colors.transparent,

            body: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),

              child: pages[_.indexPage]
            )
          ),
        );
      }
    );
  }
}


// DRAWER MENU
class _Menu extends StatelessWidget {

  final VoidCallback onTapSearchUser;
  final VoidCallback onTapShowFriends;  
  final VoidCallback onTapShowRequest;

  const _Menu({Key key, this.onTapSearchUser, this.onTapShowFriends, this.onTapShowRequest}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color buttonColor = MyInfo.isDarkMode != true ?
      Colors.blueGrey : Colors.black;

    return Padding(
      padding: const EdgeInsets.only(left:8.0),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //SEARCH USER
          CupertinoButton(
            color: buttonColor,
            onPressed: onTapSearchUser,

            child: Teexts().label('Buscar usuario', 20.0, Colors.white),
          ),

            SizedBox(height: 15.0),

          //SEARCH USER
          CupertinoButton(
            color: buttonColor,
            onPressed: onTapShowFriends,

            child: Teexts().label('Amigos', 20.0, Colors.white),
          ),

            SizedBox(height: 15.0),

          //FRIEND REQUEST
          CupertinoButton(
            color: buttonColor,
            onPressed: onTapShowRequest,

            child: Teexts().label('Solicitudes', 20.0, Colors.white),
          ),

            SizedBox(height: 15.0),

          //SETTINGS
          CupertinoButton(
            color: buttonColor,
            onPressed: (){
              Nav().to(MessageAppSettings());
            },

            child: Teexts().label('Configuracion', 20.0, Colors.white),
          ),

        ]
      ),
    );
  }
}



//SEARCH USERS
class _SearchUsers extends StatelessWidget {

  const _SearchUsers({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetBuilder<MessageAppDrawerChatListController>(
        builder: (_) {
          return Column(
            children: [
              //ICONBUTTON FOR BACK TO PREVIOUS PAGE
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.cancel),
                    color: MyInfo.isDarkMode != true ?
                      Colors.white : Colors.black,

                    iconSize: 50.0,

                    onPressed: () => _.onTapChangeView(0)
                  ),

                  Spacer(),

                  IconButton(
                    icon: Icon(Icons.qr_code),
                    color: MyInfo.isDarkMode != true ?
                      Colors.white : Colors.black,
                      
                    iconSize: 50.0,

                    onPressed: (){
                      Nav().to(PageScanQrCode());
                    },
                  )
                ],
              ),

              //TEXTFIELD FOR SEARCH USERS
              Container(
                padding: EdgeInsets.all(6.0),
                margin: EdgeInsets.symmetric(horizontal: 10.0),
                decoration: BoxDecoration(
                  color: MyInfo.isDarkMode != true ?
                    Colors.white : Colors.black12,

                  borderRadius: BorderRadius.all(Radius.circular(20.0))
                ),

                child: textiFieldSearch(
                  'Buscar', 
                  20.0, 
                  _.searchUserController,
                  (value) => _.onChangeSearchTextField()
                )
              ),

              //USERS LIST
              _.userss.length == 0 ?
                Loadings().circularLoaded()
                :
                Expanded(
                  child: GetBuilder<MessageAppDrawerChatListController>(
                    id: 'SearchUsers',
                    builder: (__) {
                      return ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: __.userss.length,
                        itemBuilder: (context, index){

                          if(__.userss[index].name.contains(__.searchUserController.text)){
                            
                            return _CardContainer(
                              user: __.userss[index],
                              onTapCard: () => _.seeUserProfile(__.userss[index]),
                            );

                          } else {
                            return SizedBox(height: 0.0);
                          }
                        }
                      );
                    }
                  )
                )
            ],
          );
        }
      ),
    );
  }


  Widget textiFieldSearch(String title,double fontSize,
                          TextEditingController controller,
                          Function onChanged
  ){
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: TextStyle(fontSize: fontSize),

      decoration: InputDecoration(    
        hintText: title,
        border: InputBorder.none,
        hintStyle: TextStyle(
          color: Colors.black,
          fontSize: fontSize, 
          fontWeight: FontWeight.w900
        )
      ),
    );
  }
}



//PAGE FOR SHOW FRIENDS
class _ShowMyFriends extends StatelessWidget {

  const _ShowMyFriends({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MessageAppDrawerChatListController>(
      id: 'myFriendsContainer',
      builder: (_) {
        return SafeArea(
          child: Column(
            children: [
              //ICONBUTTON FOR BACK TO PREVIOUS PAGE
              Align(
                alignment: Alignment.centerLeft,

                child: IconButton(
                  icon: Icon(Icons.cancel),
                  color: MyInfo.isDarkMode != true ?
                    Colors.white : Colors.black,

                  iconSize: 50.0,

                  onPressed: () => _.onTapChangeView(0)
                ),
              ),

              Teexts().label('Amigos', 24.0, Colors.white),

              //MY FFIENDS LIST
              _.myFriends.length == 0 ?
                Loadings().circularLoaded()
                :
                Expanded(
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: _.myFriends.length,
                    itemBuilder: (context, index){
                      return _CardContainer(
                        user: _.myFriends[index],
                        onTapCard: () => _.seeFriendProfile(_.myFriends[index]),
                      );
                    }
                  )
                )
            ],
          ),
        );
      }
    );
  }
}


class _ShowRequest extends StatelessWidget {

  const _ShowRequest({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MessageAppDrawerChatListController>(
      id: 'friendsRequestContainer',
      builder: (_) {
        return SafeArea(
          child: Column(
            children: [
              //ICONBUTTON FOR BACK TO PREVIOUS PAGE
              Align(
                alignment: Alignment.centerLeft,

                child: IconButton(
                  icon: Icon(Icons.cancel),
                  color: MyInfo.isDarkMode != true ?
                    Colors.white : Colors.black,

                  iconSize: 50.0,

                  onPressed: () => _.onTapChangeView(0)
                ),
              ),

              Teexts().label('Solicitudes', 24.0, Colors.white),

              //FRIENDS REQUEST LIST
              _.friendsRequest.length == 0 ?
                SizedBox(height: 0.0)
                :
                Expanded(
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: _.friendsRequest.length,
                    itemBuilder: (context, index){

                      return _CardContainer(
                        user: _.friendsRequest[index],
                        onTapCard: (){
                          MessageAppAlertDialogs().messageAppShowUserImage(
                            _.friendsRequest[index].photoUrl
                          );
                        },
                        friendRequest: true,
                        acceptRequest: () => _.acceptRequest(_.friendsRequest[index]),
                      );
                    }
                  )
                ),
            ]
          ),
        );
      }
    );
  }
}


class _CardContainer extends StatelessWidget {

  final UserInfo user;
  final VoidCallback onTapCard;
  final bool friendRequest;
  final VoidCallback acceptRequest;

  const _CardContainer({Key key, this.user, this.onTapCard, this.friendRequest, this.acceptRequest}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTapCard,

      child: Container(
        padding: EdgeInsets.all(4.0),
        margin: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: MyInfo.isDarkMode != true ?
           Colors.white : Colors.black54,

          border: Border.all(color: Colors.purple, width: 3.0),
          borderRadius: BorderRadius.all(Radius.circular(20.0))
        ),

        child: Row(
          children: [
            //FRIEND PHOTO
            Imagee().imageContainer(size: 70.0, imageUrl: user.photoUrl),

              SizedBox(width: 5.0),

            //FRIEND NAME
            Expanded(
              child: Text(
                user.name,
                
                style: TextStyle(fontSize: 20.0),
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                maxLines: 2,
              ),
            ),

            //ACCEPTED FRIEND REQUEST
            friendRequest != true ?
              SizedBox(height: 0.0)
              :
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0),

                child: Buttons().acceptButton(50.0, acceptRequest)
              )

          ],
        ),
      ),
    );
  }
}