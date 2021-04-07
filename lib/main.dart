import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/state_manager.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:portafolio/src/services/myInfo.dart';
import 'package:portafolio/src/services/pushNotifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:portafolio/src/navigation.dart';

import 'package:portafolio/src/splashScreen.dart';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';



void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  //USED FOR PUT DATES AND HOURS IN FORMAT SPANISH
  initializeDateFormatting('es'); 

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarIconBrightness: Brightness.light,/* set Status bar icons color in Android devices.*/    
  ));

  //LOCK SCREEN ORIENTATION
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);


  //GET POSTAL CODE AND ISDARKMODE FROM SHARED PREFERENCES
  //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  SharedPreferences preferences = await SharedPreferences.getInstance();

  String codePostal = preferences.getString('postalCode');
  MyInfo.myPostalCode = codePostal;

  bool themee = preferences.getBool('darkMode');
  if(themee != null){
    MyInfo.isDarkMode = themee;
  }
  //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


  //CHECK IF LOGGED USER
  //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  await Firebase.initializeApp();

  User userRegister = FirebaseAuth.instance.currentUser;
  
  if(userRegister != null){
    MyInfo.myUserID = userRegister.uid;
  }
  //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  
  
  runApp(
    GetBuilder<MainController>(
      init: MainController(),
      builder: (__) {
        return MaterialApp(
          navigatorKey: navigatorKey,
          theme: __.isDarkMode == true ? 
            ThemeData.dark() : ThemeData.light(),

          home: SplasScreen(
            isLogged: userRegister == null ? false : true
          )
          //userRegister == null ? WelcomeAppOnboardingPage() : WelcomeAppHome()
        );
      }
    )
  );

}



class MainController extends GetxController {
  
  bool isDarkMode = MyInfo.isDarkMode;

  void changeTheme(bool value){
    isDarkMode = value;
    update();
  }

  @override
  void onReady() {    
    super.onReady();

    PushNotications().initNotifications();
  }

}

