import 'package:flutter/material.dart';

class Imagee {

  Widget imageContainerBorder({double size,String imageUrl,Color colorBorder}){
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: colorBorder, width: 10.0)
      ),

      child: ClipOval(

        child: FadeInImage(
          fit: BoxFit.cover,
          fadeInDuration: Duration(milliseconds: 500),
          placeholder: AssetImage('images/loading.gif'),
          image: NetworkImage(imageUrl),
        ),
      ),
    );
  }


  Widget imageContainer({double size,String imageUrl}){
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
      ),

      child: ClipOval(
        
        child: FadeInImage(
          fit: BoxFit.cover,
          fadeInDuration: Duration(milliseconds: 500),
          placeholder: AssetImage('images/loading.gif'),
          image: NetworkImage(imageUrl),
        ),
      ),
    );
  }

  Widget squareImage(String imageUrl,{BoxFit boxFit = BoxFit.fill}){
    return FadeInImage(
      fit: boxFit,
      fadeInDuration: Duration(milliseconds: 500),
      placeholder: AssetImage('images/loading.gif'),
      image: NetworkImage(imageUrl),
    );
  }

  Widget imageMessage(String imageUrl){
    return Container(
      height: 200.0,
      width: 200.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.fill
        )
      ),
    );
  }


}