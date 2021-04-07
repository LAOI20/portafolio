import 'package:portafolio/src/services/myInfo.dart';

import 'package:flutter/material.dart';


class Teexts {

  Widget label(String text, double fontSize, Color color, {FontWeight fontWeight}){
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        color: MyInfo.isDarkMode != true ? 
          color : Colors.white60,
          
        fontWeight: fontWeight
      ),
    );
  }


  Widget labelExpanded({String text, double fontSize,
                        Color color, int maxLines
  }){
    return Text(
      text,

      style: TextStyle(
        color: MyInfo.isDarkMode != true ?
          color : Colors.white60,

        fontSize: fontSize
      ),
      overflow: TextOverflow.ellipsis,
      softWrap: false,
      maxLines: maxLines,
    );
  }

  Widget textfield(String title, double fontSize, TextEditingController controller, 
                  {bool obscure, TextInputType type, TextInputAction action, 
                   TextAlign align, Function onSubmi,Function onChanged}){
    return TextField(
      controller: controller,
      obscureText: obscure == null ? false : true,   
      keyboardType: type, 
      onSubmitted: onSubmi,
      onChanged: onChanged,
      textInputAction: action,
      textAlign: align == null ? TextAlign.start : align,
      style: TextStyle(fontSize: fontSize),

      decoration: InputDecoration(    
        hintText: title,
        hintStyle: TextStyle(
          color: Colors.black,
          fontSize: fontSize, 
          fontWeight: FontWeight.w900
        )
      ),
    );
    
  }


  Widget messageAppSearchConversation(TextEditingController controller,
                                      FocusNode foco,Function onChange
                                      ){
    return TextField(
      controller: controller,
      autocorrect: false,
      enableSuggestions: false,
      keyboardType: TextInputType.visiblePassword,
      focusNode: foco,
      onChanged: onChange,
      style: TextStyle(fontSize: 22.0, color: Colors.white),
      decoration: InputDecoration(                             
        hintText: 'Buscar',
        hintStyle: TextStyle(
          color: Colors.white,
          fontSize: 22.0, 
          fontWeight: FontWeight.w900,                      
        )
      ),
    );
  }

  Widget messageAppSendMessageTextField(TextEditingController controller,
                                        FocusNode foco,Function onChange
                                      ){
    return TextField(
      controller: controller,
      focusNode: foco,
      style: TextStyle(fontSize: 16.0),
      keyboardType: TextInputType.multiline,
      maxLines: null,
      onChanged: onChange,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(6.0),
        //fillColor: Colors.grey[400],
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide(width: 3.0),
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 3.0, color: Colors.purple[900]),
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        )
      ),
    );
  }

}