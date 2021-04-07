import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:portafolio/src/navigation.dart';

import 'package:portafolio/src/welcomeApp/pages/a-welcome.dart';
import 'package:portafolio/src/widgets/textfield.dart';

import 'package:flutter/material.dart';


class WelcomeAppAlertDialogs {

  signOut(BuildContext context){
    return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          contentPadding: EdgeInsets.all(0.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))
          ),

          content: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),

              child: Teexts().label(
                '¿Estas seguro de cerrar sesion?', 
                20.0, 
                Colors.black
              ),
            ),
          ),

          actions: [
            MaterialButton(
              child: Text('Si'),
              onPressed: (){ 
                signOutMethod();
                Nav().toUntil(WelcomeAppWelcome());
              }
            ),
            MaterialButton(
              child: Text('No'),
              onPressed: (){ Nav().back(); }
            ),
          ],
        );
      }
    );
  }

  void signOutMethod(){
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    GoogleSignIn googleSignIn = GoogleSignIn();
    FacebookAuth facebookAuth = FacebookAuth.instance;


    User user = firebaseAuth.currentUser;

    if(user.providerData[0].providerId == 'google.com'){
      googleSignIn.signOut();
    }
    if(user.providerData[0].providerId == 'facebook.com'){
      facebookAuth.logOut();
    }

    firebaseAuth.signOut();

  }

}