import 'package:get/state_manager.dart';
import 'package:portafolio/src/services/myInfo.dart';

import 'package:portafolio/src/messagesApp/controllers/aaa-friendProfileC.dart';

import 'package:portafolio/src/messagesApp/widgets/alertDialogs.dart';
import 'package:portafolio/src/widgets/backgroundImage.dart';
import 'package:portafolio/src/widgets/imagee.dart';
import 'package:portafolio/src/widgets/textfield.dart';

import 'package:flutter/material.dart';

class MessageAppFriendProfile extends StatelessWidget {

  final bool writeMessage;
  
  const MessageAppFriendProfile({Key key, this.writeMessage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MessageAppFriendProfileController>(
      init: MessageAppFriendProfileController(),
      builder: (_) {
        return Scaffold(

          body: backgroundImage(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),

              child: Stack(
                children: [
                  
                  //RED CONTAINER AND FRIEND NAME
                  _RedContainerNameFriend(friendName: _.friendREF.name),

                  //FRIEND IMAGE
                  _FriendImage(imageUrl: _.friendREF.photoUrl),

                  //FRIEND INFO 
                  //MULTIMEDIA FILES 
                  //FEATURED MESSAGES
                  //FRIENDS IN COMMON
                  _BodyPage(
                    friendInfo: _.friendREF.info,
                    onTapFriendsCommon: () => _.seeFriendsCommon(context),
                    onTapSharedFiles: () => _.seeSharedFiles(context),
                    onTapFeaturedMessages: () => _.seeFeaturedMessages(context),
                  )

                ],
              ),
            ),
          ),

          floatingActionButton: writeMessage != true ?
            SizedBox(height: 0.0)
            :
            FloatingActionButton(
              onPressed: () => _.onTapWriteMessage(),

              child: Icon(Icons.message),
            )
        );
      }
    );
  }
}


class _RedContainerNameFriend extends StatelessWidget {

  final String friendName;

  const _RedContainerNameFriend({Key key, this.friendName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.25,
      width: size.width,
      color: MyInfo.isDarkMode != true ?
        Colors.blueGrey : Colors.black87,
        
      alignment: Alignment.topLeft,

      child: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          
          child: Teexts().label(friendName, 25.0, Colors.white)
        )
      ),
    );
  }
}


class _FriendImage extends StatelessWidget {

  final String imageUrl;

  const _FriendImage({Key key, this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.only(
        top: size.height * 0.12,
      ),

      child: GestureDetector(
        onTap: (){ 
          MessageAppAlertDialogs().messageAppShowUserImage(
            imageUrl            
          ); 
        },
        
        child: Center(
          child: Imagee().imageContainerBorder(
            size: 150.0,
            imageUrl: imageUrl,
            colorBorder: MyInfo.isDarkMode != true ?
              Colors.purple : Colors.black
          )
        ),
      ),
    );
  }
}


class _BodyPage extends StatelessWidget {

  final String friendInfo;
  final VoidCallback onTapFriendsCommon;
  final VoidCallback onTapSharedFiles;
  final VoidCallback onTapFeaturedMessages;

  const _BodyPage({Key key, this.friendInfo, this.onTapFriendsCommon, this.onTapSharedFiles, this.onTapFeaturedMessages}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.only(
        top: size.height * 0.45,
        left: 10.0,
        right: 10.0
      ),

      child: Column(
        children: [
          //FRIEND INFO
          Container(                      
            width: size.width,
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.purple,
              borderRadius: BorderRadius.all(Radius.circular(25.0))
            ),

            child: Teexts().label(
              friendInfo, 
              22.0,
              Colors.black
            ),
          ),

            SizedBox(height: 15.0),

          _BodyContainer(
            title: 'Amigos en comun',
            icon: Icons.supervised_user_circle,
            onTap: onTapFriendsCommon
          ),

          _BodyContainer(
            title: 'Archivos multimedia',
            icon: Icons.image,
            onTap: onTapSharedFiles
          ),

          _BodyContainer(
            title: 'Mensajes destacados',
            icon: Icons.star,
            onTap: onTapFeaturedMessages
          ),

            SizedBox(height: 75.0),            
        ],
      ),
    );
  }
}

class _BodyContainer extends StatelessWidget {

  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _BodyContainer({this.title, this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: onTap,
      
      child: Container(
        width: size.width,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.all(8.0),
        margin: EdgeInsets.symmetric(vertical: 7.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
          border: Border.all(width: 2.0, color: Colors.black)
        ),

        child: Row(
          children: [
            Icon(icon, size: 40.0,),
            Teexts().label(title, 20.0, Colors.black),
          ],
        ),
      ),
    );
  }

}