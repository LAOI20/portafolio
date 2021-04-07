import 'dart:ui';
import 'package:get/state_manager.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:get/instance_manager.dart';

import 'package:portafolio/src/navigation.dart';

import 'package:portafolio/src/messagesApp/controllers/ab-settingsC.dart';

import 'package:portafolio/src/widgets/textfield.dart';

import 'package:flutter/material.dart';


class MessageAppAlertDialogs {


  //USE IN PAGE AB-SETTINGS
  messageAppChangeInfo(){ 
    final controller = Get.find<MessageAppSettingsController>();
    
    TextEditingController userName = 
      TextEditingController(text: controller.myProfile.name);
    
    TextEditingController userInfo = 
      TextEditingController(text: controller.myProfile.info);

    return showDialog(
      context: navigatorKey.currentContext,
      builder: (context){
        Size size = MediaQuery.of(context).size;

        return AlertDialog(
          contentPadding: EdgeInsets.all(0.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))
          ),

          content: SingleChildScrollView(
            child: Container(
              width: size.width,
              padding: EdgeInsets.all(8.0),
              
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Teexts().label('Nombre', 22.0, Colors.black),
                  Teexts().textfield('', 19.0, userName),

                    SizedBox(height: 30.0),

                  Teexts().label('Sobre mi', 22.0, Colors.black),
                  TextField(
                    controller: userInfo,
                    maxLines: null,
                    style: TextStyle(fontSize: 19.0),
                  ),

                    SizedBox(height: 15.0),
                ]
              )
            ),
          ),

          actions: [
            TextButton(
              onPressed: (){
                controller.changeNameOrInfo(
                  newUserName: userName.text,
                  newUserInfo: userInfo.text
                );
              }, 

              child: Teexts().label('Listo', 17.0, Colors.blue)
            )
          ],
        );
      }
    );
  }



  //USE IN PAGE AB-SETTINGS
  messageAppShowCodeQR(String dataQR){
    return showDialog(      
      barrierColor: Colors.transparent,
      context: navigatorKey.currentContext,
      builder: (context){
        Size size = MediaQuery.of(context).size;

        return Container(
          height: size.height,
          width: size.width,

          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),

            child: Padding(
              padding: EdgeInsets.symmetric(vertical: size.height * 0.2),

              child: Container(
                height: size.height * 0.5,
                width: size.width,

                child: Column(
                  children: [
                    Expanded(
                      child: QrImage(
                        data: dataQR,
                        backgroundColor: Colors.white,
                      ),
                    ),

                      SizedBox(height: 8.0),

                    Teexts().label('Al dar tu codigo qr\nsera mas facil encontrartre\nentre todos los usuarios', 
                      20.0, 
                      Colors.black
                    )
                  ]
                ),
              )
            ),
          ),
        );
      }
    );
  }



  //USE IN PAGE A-CHAT-LIST | AB-SETTINGS
  messageAppShowUserImage(String photoUrl){
    return showDialog(
      barrierColor: Colors.transparent,
      context: navigatorKey.currentContext,
      builder: (context){
        Size size = MediaQuery.of(context).size;

        return Container(
          height: size.height,
          width: size.width,

          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),

            child: Padding(
              padding: EdgeInsets.symmetric(vertical: size.height * 0.2),

              child: MessageAppUserImage(photoUrl: photoUrl) //THE CLASS AT THE END OF THE FILE
            ),
          ),
        );
      }
    );
  }
  

}


//IT IS NECESSARY TO BE ABLE TO ZOOM THE IMAGE
class MessageAppUserImage extends StatefulWidget {

  final String photoUrl;

  MessageAppUserImage({Key key, this.photoUrl}) : super(key: key);

  @override
  _MessageAppUserImageState createState() => _MessageAppUserImageState();
}

class _MessageAppUserImageState extends State<MessageAppUserImage> {

  TransformationController _transformationController = TransformationController();
  TapDownDetails _doubleTapDetails;

  void onDoubleTapDown(TapDownDetails details){
    _doubleTapDetails = details;
  }

  void onDoubleTapp(){
    if(_transformationController.value != Matrix4.identity()){

       _transformationController.value = Matrix4.identity();

    } else {
      
      final position = _doubleTapDetails.localPosition;

      
        _transformationController.value = Matrix4.identity()
        ..translate(-position.dx * 2, -position.dy * 2)
        ..scale(3.0);
      
    }
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onDoubleTapDown: (tapDetails){
        onDoubleTapDown(tapDetails);
      },
      onDoubleTap: (){
        onDoubleTapp();
      },

      child: InteractiveViewer(
        transformationController: _transformationController,

        child: Container(
          height: size.height * 0.5,
          width: size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(widget.photoUrl),
              fit: BoxFit.fill
            )
          ),
        ), 
      ),
    );
  }
}