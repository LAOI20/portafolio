import 'package:portafolio/src/services/myInfo.dart';
import 'package:get/state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:portafolio/src/navigation.dart';

import 'package:portafolio/src/welcomeApp/controllers/b-homeC.dart';
import 'package:portafolio/src/messagesApp/controllers/a-chatListC.dart';
import 'package:portafolio/src/messagesApp/controllers/ad-drawerChatListC.dart';

import 'package:portafolio/src/messagesApp/models/ab-settingsM.dart';

import 'package:portafolio/src/messagesApp/database/ab-settingsD.dart';

import 'package:portafolio/main.dart';

class MessageAppSettingsController extends GetxController {

  final mainController = Get.find<MainController>();
  final drawerController = Get.find<MessageAppDrawerChatListController>();
  final chatListController = Get.find<MessageAppChatListController>();
  final welcomeController = Get.find<WelcomeAppHomeController>();

  
  bool loadedData = false;

  MyProfile myProfile;

  @override
  void onInit() {
    super.onInit();
    
    MessageAppSettingsDatabase().getUserData().then((userData){
      myProfile = userData;

      loadedData = true;
      update();
    });
  }


//EVENTS TEXTFIELDS USE IN PAGE AND BOTTOM SHEET
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  void changeNameOrInfo({String newUserName,String newUserInfo}){

    if(newUserName != '' && newUserInfo != ''){

      if(newUserName != myProfile.name || newUserInfo != myProfile.info){

        MessageAppSettingsDatabase().changeMyNameOrInfo(newUserName, newUserInfo)
          .then((value){
            
            myProfile.name = newUserName;
            myProfile.info = newUserInfo;

            update();

            MyInfo.myName = newUserName;
            MyInfo.myInfo = newUserInfo;

            Nav().back();
          });
      }
      
    }
  }

//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<










  //CHANGE MY PROFILE PHOTO
  void takePhoto(){
    MessageAppSettingsDatabase().updateMyPhoto(false).then((value){
      if(value != null){
        myProfile.photoUrl = value;
        MyInfo.myPhotoUrl = value;

        Nav().back();
      }
      update();
    });
  }


  void selectPhoto(){
    MessageAppSettingsDatabase().updateMyPhoto(true).then((value){
      if(value != null){
        myProfile.photoUrl = value;
        MyInfo.myPhotoUrl = value;

        Nav().back();
      }
      update();
    });
  }


  //CHANGE THEME WHEN PRES THE SWITCH
  bool darkThemee = MyInfo.isDarkMode;

  void changeTheme(bool value) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();    
    preferences.setBool('darkMode', value);

    MyInfo.isDarkMode = value;
    darkThemee = value;

    mainController.changeTheme(value);
    
    update();
    drawerController.update();
    chatListController.update();
    welcomeController.update();
  }


  void openWhatsapp() async{
    String url = 'whatsapp://send?phone=+523741078455&text=Hola';

    await canLaunch(url) ?
      launch(url) : print('ERROR');
  }

  

}