import 'package:portafolio/src/widgets/textfield.dart';

import 'package:flutter/material.dart';

class EcommerceAppContainerAppBar {

  //USE IN PAGE AC-MY-ACCOUNT | ACA-OFFCIAL-STORE
  Widget appBar({String title,Color color,double height,double width}){
    return Container(
      height: height,
      width: width,          
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(40.0))
      ),

      child: SafeArea(
        child: Teexts().label(title, 30.0, Colors.black)
      )
    );
  }

}