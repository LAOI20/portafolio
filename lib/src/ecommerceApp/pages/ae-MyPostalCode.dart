import 'dart:ui';
import 'package:portafolio/src/services/myInfo.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:portafolio/src/navigation.dart';

import 'package:portafolio/src/widgets/alertMessage.dart';
import 'package:portafolio/src/widgets/buttons.dart';
import 'package:portafolio/src/widgets/textfield.dart';

import 'package:flutter/material.dart';


class EcommerceAppMyPostalCode extends StatelessWidget {

  final TextEditingController postalCodeController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () => Future.value(false),

      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),

        child: Scaffold(
          backgroundColor: Colors.transparent,

          body: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),

            child: Center(

              child: Container(
                margin: EdgeInsets.all(15.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20.0))
                ),

                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Teexts().label(
                      'Ingresa tu codigo postal', 
                      22.0, 
                      Colors.black
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),

                      child: Teexts().textfield(
                        '', 
                        20.0, 
                        postalCodeController,
                        type: TextInputType.number,
                        align: TextAlign.center
                      ),
                    ),

                    Buttons().acceptButton(60.0, () { 
                      String value = postalCodeController.text.trim();

                      if(value.length == 5){
                        correctPostalCode(value);
                      } else {
                        AlertMessage().alertaMensaje(
                          'Codigo postal incorrecto \nDebe tener cinco digitos'
                        );
                      }

                    })
                  ]
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }


  void correctPostalCode(String value) async{    
    SharedPreferences preferences = await SharedPreferences.getInstance();

    preferences.setString('postalCode', value);

    MyInfo.myPostalCode = value;

    Nav().back();
  }

}