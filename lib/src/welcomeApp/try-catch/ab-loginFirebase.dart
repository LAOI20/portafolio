import 'package:portafolio/src/services/myInfo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:portafolio/src/welcomeApp/database/ab-loginFirebaseD.dart';

import 'package:portafolio/src/widgets/alertMessage.dart';

import 'package:flutter/material.dart';


class WelcomeAppLoginFirebaseTryCatch {

  //CODE SMS FOR AUTH PHONE NUMBER

  FirebaseAuth _authFirebase = FirebaseAuth.instance;
  GoogleSignIn googleSignIn = GoogleSignIn();
  FacebookAuth facebookAuth = FacebookAuth.instance;

  Future<bool> tryLoginEmailPassword(BuildContext context,String email,String password) async{    

    try {

      UserCredential user = await _authFirebase.signInWithEmailAndPassword(
        email: email, 
        password: password
      );  

      MyInfo.myUserID = user.user.uid;

      return true;      

    } catch (e) {
      print(e);
      if(e is FirebaseAuthException){
        switch (e.code) {
          case 'invalid-email':
            AlertMessage().alertaMensaje('Email invalido');
            break;            
          case 'user-not-found':
            AlertMessage().alertaMensaje('Usuario no encontrado');
            break;            
          case 'wrong-password':
            AlertMessage().alertaMensaje('Contraseña incorrecta');
            break;
          default:
        }
      }
      return false;
    }
  }


  Future<bool> tryLoginFacebook() async{

    try {
      
      Map<String, dynamic> userData;

      LoginResult loginResult = await facebookAuth.login();

      AuthCredential credential = FacebookAuthProvider.credential(loginResult.accessToken.token);

      UserCredential userr = await _authFirebase.signInWithCredential(credential);

      userData = await facebookAuth.getUserData();

      WelcomeAppLoginFirebaseDatabase().checkUserExists(
        userr, userData['name']
      );

      return true;
      
      
    } catch (e) {
      print('aquiii error $e');
      
      return false;
    }
  }


  Future<bool> tryLoginGoogle() async{
    try {
      bool result;

      GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
      
      if(googleSignInAccount != null){
        
        GoogleSignInAuthentication googleAuth = await googleSignInAccount.authentication;
      
        AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken
        );

        UserCredential userr = await _authFirebase.signInWithCredential(credential);
                
        WelcomeAppLoginFirebaseDatabase().checkUserExists(
          userr, userr.user.displayName
        );

        result = true;

      } else {
        print('google sign in account nulllllll');
        result = false;
      }

      return result;

    } catch (e) {
      print("catchhhhh $e");
      return false;
    }
  }



  Future tryLoginPhone(String phoneNumber) async{
    final PhoneVerificationCompleted verificationCompleted =
      (AuthCredential phoneAuthCredential) async {    
        final res = await _authFirebase.signInWithCredential(phoneAuthCredential);

        WelcomeAppLoginFirebaseDatabase().checkUserExists(
          res, 'new user'
        );
      };
    
    final PhoneVerificationFailed verificationFailed =
      (FirebaseAuthException authException) {
        print('Auth Exception is ${authException.message}');
      };
    
    final PhoneCodeSent codeSent =
      (String verificationId, [int forceResendingToken]) async {
        String verId = verificationId;
        print(verId);
      };
    
    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
      (String verificationId) {
        String verId = verificationId;
        print(verId);
      }; 

    
    try {
      
      await _authFirebase.verifyPhoneNumber(
        phoneNumber: phoneNumber, 
        timeout: const Duration(seconds: 30),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout
      );

    } catch (e) {
      print('EEEEERRRRROOOOORRRRR');
      print(e);
    }
  }

}