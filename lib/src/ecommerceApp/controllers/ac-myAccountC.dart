import 'package:get/state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:portafolio/src/ecommerceApp/models/ac-myAccountM.dart';
import 'package:portafolio/src/welcomeApp/controllers/b-homeC.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:portafolio/src/services/myInfo.dart';

import 'package:portafolio/src/ecommerceApp/controllers/a-homeC.dart';

import 'package:portafolio/src/ecommerceApp/database/ac-myAccountD.dart';

import 'package:portafolio/main.dart';

import 'package:portafolio/src/widgets/alertMessage.dart';
import 'package:flutter/material.dart';

class EcommerceAppMyAccountController extends GetxController {

  bool isLoaded = false;

  final mainController = Get.find<MainController>();
  final homeController = Get.find<EcommerceAppHomeController>();
  final welcomeController = Get.find<WelcomeAppHomeController>();


  List<ProductHistorial> historialProducts = [];


  @override
  void onInit() {
    super.onInit();

    EcommerceAppMyAccountDatabase().getMyHistorial()
      .then((valueList){
        historialProducts = valueList;

        isLoaded = true;
        update();
      });
  }





  void onChangeTheme(bool value) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();    
    preferences.setBool('darkMode', value);

    MyInfo.isDarkMode = value;
    
    mainController.changeTheme(value);
    
    update();
    homeController.update();
    welcomeController.update();
  }


  void changePostalCode(BuildContext context,String postalCode) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();

    preferences.setString('postalCode', postalCode);

    MyInfo.myPostalCode = postalCode;

    update();

    Navigator.pop(context);
    AlertMessage().alertaMensaje('Listo codigo postal cambiado');
  }


}