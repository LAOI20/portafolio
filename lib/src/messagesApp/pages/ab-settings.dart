import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/state_manager.dart';
import 'package:portafolio/src/services/myInfo.dart';

import 'package:portafolio/src/messagesApp/controllers/ab-settingsC.dart';

import 'package:portafolio/src/messagesApp/widgets/alertDialogs.dart';
import 'package:portafolio/src/messagesApp/widgets/cupertino.dart';
import 'package:portafolio/src/widgets/buttons.dart';
import 'package:portafolio/src/widgets/imagee.dart';
import 'package:portafolio/src/widgets/loadings.dart';
import 'package:portafolio/src/widgets/textfield.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class MessageAppSettings extends StatelessWidget {
  const MessageAppSettings({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        
        child: Container(
          padding: EdgeInsets.only(
            top: 55.0,
            bottom: 30.0,
            left: 8.0,
            right: 8.0
          ),
        
          child: GetBuilder<MessageAppSettingsController>(
            init: MessageAppSettingsController(),
            builder: (_) { 
              return _.loadedData == false ?
                Loadings().circularLoaded()
                :
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ProfileContainer(
                      myName: _.myProfile.name,
                      myInfo: _.myProfile.info,
                      myPhotoUrl: _.myProfile.photoUrl,

                      changePhotoTake: () => _.takePhoto(),
                      changePhotoSelect: () => _.selectPhoto(),
                    ),

                      SizedBox(height: 20.0),

                    Teexts().label('Cuenta', 30.0, Colors.black),

                    _AccountContainer(),

                    Divider(thickness: 5.0,),

                    //CHANGE THEME
                    Teexts().label('Tema', 30.0, Colors.black),

                    //CHANGE THEME BODY
                    _ChangeThemeBody(),

                    Divider(thickness: 5.0,),

                    Teexts().label('Contactanos', 30.0, Colors.black),

                    _ContactUsContainer(
                      openWhatsapp: () => _.openWhatsapp(),
                    )

                  ]
                );
            }
          ),
        ),
      ),
    );
  }

}

class _ProfileContainer extends StatelessWidget {

  final String myPhotoUrl;
  final String myName;
  final String myInfo;  
  final VoidCallback changePhotoTake;
  final VoidCallback changePhotoSelect;

  const _ProfileContainer({Key key, this.myPhotoUrl, this.myName, this.myInfo, this.changePhotoTake, this.changePhotoSelect}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6.0),
      decoration: BoxDecoration(
        color: MyInfo.isDarkMode != true ?
          Colors.blueGrey : Colors.black54,

        borderRadius: BorderRadius.all(Radius.circular(20.0))
      ),

      child: Column(
        children: [
          //USER IMAGE AND EDIT IMAGE
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: (){ 
                  MessageAppAlertDialogs().messageAppShowUserImage(
                    myPhotoUrl
                  ); 
                },
                
                child: Imagee().imageContainer(
                  size: 100.0, imageUrl: myPhotoUrl
                )
              ),

              Buttons().buttonIcon(Icons.edit, 30.0, () { 
                MessageAppCupertino().showCupertinoActions(
                  context: context,
                  onTapTakePhoto: changePhotoTake,
                  onTapSelectPhoto: changePhotoSelect
                );
              })
            ],
          ),
          

            SizedBox(height: 10.0),

          //USER NAME - USER INFO AND EDIT NAME OR INFO
          Row(
            children: [
              Teexts().label(myName, 23.0, Colors.black),

              Buttons().buttonIcon(Icons.edit, 30.0, () { 
                MessageAppAlertDialogs().messageAppChangeInfo();
              })
            ],
          ),

            SizedBox(height: 4.0),

          Align(
            alignment: Alignment.centerLeft,

            child: Teexts().label(
              myInfo, 
              18.0, 
              Colors.black
            )
          ),

            SizedBox(height: 15.0)
        ]
      ),
    );
  }
}

class _AccountContainer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.only(
        top: 10.0,
        bottom: 10.0,
        left: size.width * 0.12
      ),

      child: GestureDetector(
        onTap: (){ 
          MessageAppAlertDialogs().messageAppShowCodeQR(
            MyInfo.myUserID
          ); 
        },

        child: Row(
          children: [
            Icon(Icons.qr_code, size: 30.0),

              SizedBox(width: 8.0),

            containerOnTap('Codigo QR', (){ 
              MessageAppAlertDialogs().messageAppShowCodeQR(
                MyInfo.myUserID
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget containerOnTap(String text,VoidCallback onTap){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.0),

      child: GestureDetector(
        onTap: onTap,
        
        child: Teexts().label(text, 22.0, Colors.black)
      ),
    );
  }

}


class _ChangeThemeBody extends StatelessWidget {
  const _ChangeThemeBody({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.only(
        top: 15.0,
        bottom: 15.0,
        left: size.width * 0.12,
      ),

      child: GetBuilder<MessageAppSettingsController>(
        id: 'changeTheme',
        builder: (__){
          return Row(
            children: [
              CupertinoSwitch(
                value: __.darkThemee,
                onChanged: (value){ __.changeTheme(value); },
              ),

                SizedBox(width: 8.0),

              Teexts().label(
                __.darkThemee == false ? 'Claro' : 'Oscuro',
                22.0, 
                Colors.black
              )
            ],
          );
        }
      )
    );
  }
}

class _ContactUsContainer extends StatelessWidget {

  final Function openWhatsapp;

  const _ContactUsContainer({Key key, this.openWhatsapp}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.only(
        top: 15.0,
        bottom: 15.0,
        left: size.width * 0.12
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          Row(
            children: [                          
              Icon(FontAwesomeIcons.whatsapp, size: 35.0),

                SizedBox(width: 8.0),

              GestureDetector(
                onTap: openWhatsapp,
                
                child: Text(
                  '3741078455',
                  style: TextStyle(
                    fontSize: 22.0,
                    color: Colors.blue,
                    decoration: TextDecoration.underline
                  ),
                ),
              ),
              
            ]
          ),

            SizedBox(height: 15.0),

          Teexts().label('Email : aosoftware18@gmail.com', 20.0, Colors.black)
        ]
      ),
    );
  }
}