import 'package:portafolio/src/navigation.dart';

import 'package:portafolio/src/widgets/textfield.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class AlertMessage {

  alertaMensaje(String texto){
    return showDialog(
      context: navigatorKey.currentContext,
      builder: (context){
        Size size = MediaQuery.of(context).size;

        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.all(12.0),

          child: Stack(
            clipBehavior: Clip.none, 
            alignment: Alignment.center,
            
            children: [
              Container(
                width: size.width,
                height: 250.0,
                padding: EdgeInsets.all(10.0),

                decoration: BoxDecoration(
                  color: Color(int.parse('0xff1565bf')),
                  borderRadius: BorderRadius.all(Radius.circular(25.0))
                ),

                child: Center(child: Teexts().label(texto, 22.0, Colors.white))
              ),

              Positioned(
                top: -60,

                child: Container(
                  height: 110.0,
                  width: 110.0,
                  
                  decoration: BoxDecoration(
                    color: Color(int.parse('0xff1565bf')),
                    borderRadius: BorderRadius.circular(100.0)
                  ),
                  child: Icon(Icons.error_rounded, color: Colors.white, size: 110.0)
                ),
              )
            ],
          ),
        );
      }
    );
  }   


}

