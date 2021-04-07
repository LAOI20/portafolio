import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/state_manager.dart';

import 'package:portafolio/src/navigation.dart';

import 'package:portafolio/src/welcomeApp/database/ab-loginFirebaseD.dart';

import 'package:portafolio/src/welcomeApp/try-catch/ab-loginFirebase.dart';

import 'package:portafolio/src/welcomeApp/pages/b-home.dart';

import 'package:portafolio/src/widgets/alertMessage.dart';

import 'package:flutter/material.dart';

class WelcomeAppLoginFirebaseController extends GetxController with SingleGetTickerProviderMixin{

  bool showLoadedScreen = false;

  AnimationController controllerAnimation;
  AnimationController loginIconsAnimation;

  @override
  void onInit() {
    super.onInit();

    controllerAnimation = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 4000)
    );

    loginIconsAnimation = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500)
    );

    controllerAnimation.forward().then((value){
      loginIconsAnimation.forward();
    });
  }

  
  @override
  void onClose() {
    
    controllerAnimation.dispose();
    loginIconsAnimation.dispose();
    
    super.onClose();
  }

//TEXTFIELDS OF PAGE AND BOTTOM SHEET -- AND LOGIN METHODS OR REGISTER 
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  
  //LOGIN WITH EMAIL AND PASSWORD
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  //SIGN UP WITH EMAIL AND PASSWORD
  TextEditingController nameRegisterController = TextEditingController();
  TextEditingController emailRegisterController = TextEditingController();
  TextEditingController passwordRegisterController = TextEditingController();
  

  void createUserEmailPassword(BuildContext context) async{

    if(nameRegisterController.text != '' &&
       emailRegisterController.text.contains('@') &&
       passwordRegisterController.text.length >= 5
      ){

        showLoadedScreen = true;
        update();

        try {
          FirebaseAuth firebaseAuth = FirebaseAuth.instance;

          await firebaseAuth.createUserWithEmailAndPassword(
            email: emailRegisterController.text, 
            password: passwordRegisterController.text

          ).then((value){

            WelcomeAppLoginFirebaseDatabase().createUserFirestore(
              myUser: value, name: nameRegisterController.text
            );

          });

        } catch (e) {
          print('Eeee $e');
          if(e is FirebaseAuthException){
            switch (e.code) {
              case 'email-already-in-use':
                AlertMessage().alertaMensaje('Este usuario ya existe');
                break;
              case 'invalid-email':
                AlertMessage().alertaMensaje('Email invalido');
                break;
              case 'weak-password':
                AlertMessage().alertaMensaje('Contraseña debil');
                break;
              default:
            }
          }
        }

        showLoadedScreen = false;
        update();

      } else if(nameRegisterController.text == ''){
        AlertMessage().alertaMensaje('nombre y apellido no puede estar vacio');
      } else if(passwordRegisterController.text.length < 5){
        AlertMessage().alertaMensaje('Contraseña debil');
      }

  }


  void loginWithEmailPassword(BuildContext context) async{

    if(emailController.text.contains('@') && passwordController.text.length >= 5){
      
      showLoadedScreen = true;
      update();

      WelcomeAppLoginFirebaseTryCatch().tryLoginEmailPassword(
        context, emailController.text, passwordController.text
        
      ).then((value){
        
        showLoadedScreen = false;
        update();

        if(value == true){
          Nav().toUntil(WelcomeAppHome());
        }
      });
    }

  }


  void onTapFacebook(BuildContext context) async{

    WelcomeAppLoginFirebaseTryCatch().tryLoginFacebook();      
  }

  void onTapGoogle(BuildContext context) async{

    WelcomeAppLoginFirebaseTryCatch().tryLoginGoogle();     
  }

  //METHOD USE IN BOTTOM SHEET
  void loginWithPhoneNumber(String phoneNumber){
    WelcomeAppLoginFirebaseTryCatch().tryLoginPhone(phoneNumber);
  }
  

}