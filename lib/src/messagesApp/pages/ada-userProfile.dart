import 'package:portafolio/src/services/myInfo.dart';
import 'package:get/state_manager.dart';

import 'package:portafolio/src/messagesApp/controllers/ada-userProfileC.dart';

import 'package:portafolio/src/messagesApp/models/ad-drawerChatListM.dart';

import 'package:portafolio/src/messagesApp/widgets/alertDialogs.dart';
import 'package:portafolio/src/widgets/imagee.dart';
import 'package:portafolio/src/widgets/loadings.dart';
import 'package:portafolio/src/widgets/textfield.dart';

import 'package:flutter/material.dart';


class MessageAppUserProfile extends StatelessWidget {
  const MessageAppUserProfile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    UserInfo user = MessageAppUserProfileController.userInfoo;

    return Scaffold(

      body: GetBuilder<MessageAppUserProfileController>(
        init: MessageAppUserProfileController(),
        builder: (_) {
          return _.loadedData != true ?
            Loadings().circularLoaded()
            :
            Stack(
              children: [
                //WHITE CONTAINER
                Container(
                  height: size.height,
                  width: size.width,
                  decoration: BoxDecoration(
                    color: MyInfo.isDarkMode != true ?
                      Colors.blueGrey : Colors.black54,
                      
                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(350.0))
                  ),

                  child: Column(
                    children: [
                        SizedBox(height: size.height * 0.1),
                      
                      //USER PHOTO
                      GestureDetector(
                        onTap: (){ 
                          MessageAppAlertDialogs().messageAppShowUserImage(user.photoUrl);
                        },

                        child: Imagee().imageContainerBorder(
                          colorBorder: Colors.purple,
                          size: 150.0, 
                          imageUrl: user.photoUrl
                        ),
                      ),

                        SizedBox(height: 10.0),

                      //USER INFO
                      _InfoContainer()
                      
                    ],
                  ),
                ),

                //SEND REQUEST ICONBUTTON
                Positioned(
                  bottom: 5.0,
                  right: 5.0,

                  child: _.requestSent == true ?
                    Teexts().label('Solicitud\nEnviada', 22.0, Colors.purple)
                    :
                    IconButton(
                      icon: Icon(Icons.person_add_sharp),
                      iconSize: 50.0,

                      onPressed: () => _.sendRequestToUser(),
                    ),
                )
              ],
            );
        }
      )
    );
  }
}


class _InfoContainer extends StatelessWidget {

  const _InfoContainer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    UserInfo user = MessageAppUserProfileController.userInfoo;

    return Column(
      children: [
        Teexts().label(user.name, 22.0, Colors.white),

          SizedBox(height: 10.0),

        //USER INFO
        Container(                      
          width: size.width,
          constraints: BoxConstraints(
            minHeight: size.height * 0.07,
            maxHeight: size.height * 0.2
          ),
          margin: EdgeInsets.symmetric(horizontal: 10.0),
          padding: EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Colors.purple,
            borderRadius: BorderRadius.all(Radius.circular(25.0))
          ),

          child: SingleChildScrollView(

            child: Teexts().label(
              user.info, 
              20.0,
              Colors.black
            )
          ),
        ),
      ],
    );
  }
}