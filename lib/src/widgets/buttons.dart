import 'package:flutter/material.dart';

class Buttons {

  Widget buttonIcon(IconData icon, double size, VoidCallback onPres, {Color color}){
    return IconButton(
      icon: Icon(icon),
      iconSize: size,
      onPressed: onPres,
      color: color,
    );
  } 

  Widget acceptButton(double size, VoidCallback onPres){
    return IconButton(
      icon: Icon(Icons.check_circle),
      iconSize: size,
      onPressed: onPres,
      color: Colors.green
    );
  } 

}