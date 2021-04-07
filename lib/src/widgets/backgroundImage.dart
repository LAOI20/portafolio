import 'package:portafolio/src/services/myInfo.dart';

import 'package:flutter/material.dart';


final String appNameSelect = 'none';


Widget backgroundImage({Widget child}){
  
  String assetImage;

  if(MyInfo.appNameSelect == 'Peliculas'){
    assetImage = 'Peliculas';  
  } else if(MyInfo.isDarkMode == true){
    assetImage = '${MyInfo.appNameSelect}Dark';
  } else {
    assetImage = MyInfo.appNameSelect;
  }

  return Container(
    height: double.infinity,
    width: double.infinity,
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage('images/$assetImage.jpg'),
        fit: BoxFit.fill
      )
    ),

    child: child,
  );
}