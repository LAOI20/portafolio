import 'package:get/state_manager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:portafolio/src/services/myInfo.dart';

import 'package:portafolio/src/navigation.dart';

import 'package:portafolio/src/welcomeApp/database/b-homeD.dart';

import 'package:portafolio/src/ecommerceApp/pages/a-home.dart';
import 'package:portafolio/src/messagesApp/pages/a-chatList.dart';
import 'package:portafolio/src/moviesApp/pages/a-home.dart';

import 'package:flutter/material.dart';

class WelcomeAppHomeController extends GetxController with SingleGetTickerProviderMixin {

  //CURRENT USER
  String myUserID = MyInfo.myUserID;


  //APP DESCRIPTION ANIMATION
  AnimationController descriptionAnimation;


  List<String> appsNames = ['Mensajeria', 'Ecommerce', 'Peliculas',];


  @override
  void onInit() {
    super.onInit();
    
    WelcomeAppHomeDatabase().updateStatus(true);
    WelcomeAppHomeDatabase().getMyData();
    WelcomeAppHomeDatabase().updateMyToken();
    
    descriptionAnimation = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 4000)
    );
  }

  @override
  void onReady() {
    super.onReady();

    requestPermission();
  }

  

  void requestPermission() async{
    await Permission.camera.request();
    await Permission.microphone.request();
  }


  void navigationToApp(BuildContext context,String app){
    switch (app) {
      case 'Mensajeria':
        MyInfo.appNameSelect = app;
        Nav().to(MessageAppChatList());
        break;
      case 'Ecommerce':
        MyInfo.appNameSelect = app;
        Nav().to(EcommerceAppHome());        
        break;
      case 'Peliculas':
        MyInfo.appNameSelect = app;
        Nav().to(MoviesAppHome());
        break;
      default:
    }
  }


  void initDescriptionAnimation(){
    descriptionAnimation.forward(from: 0);
  }

  void resetDescriptionAnimation(){
    descriptionAnimation.reset();
  }

}
