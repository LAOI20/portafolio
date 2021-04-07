import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:portafolio/src/services/myInfo.dart';

import 'package:portafolio/src/messagesApp/models/aa-chatScreenM.dart';
import 'package:portafolio/src/messagesApp/models/aaa-friendProfileM.dart';

import 'package:portafolio/src/messagesApp/widgets/alertDialogs.dart';
import 'package:portafolio/src/widgets/imagee.dart';
import 'package:portafolio/src/widgets/textfield.dart';

import 'package:flutter/material.dart';

class MessageAppMessageContainer {

  String myUserID = MyInfo.myUserID;

  Widget messageContainer({BuildContext context,Messageee message,
                            VoidCallback onLongPress
                          }){
    Size size = MediaQuery.of(context).size;

    //THE COLUMN IS NECCESARY FOR NOT EXPANDED THE CONTAINER
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: message.sentBy == myUserID ? 
        CrossAxisAlignment.end
        :
        CrossAxisAlignment.start,

      children: [
        GestureDetector(
          onLongPress: onLongPress,

          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 4.0,
                color: message.featured == true ?
                  Colors.amber
                  :
                  message.seen != 'not' && message.sentBy == myUserID ?
                    Colors.blue
                    :
                    Colors.black
              ),
              borderRadius: BorderRadius.all(Radius.circular(20.0))
            ),
            constraints: BoxConstraints(
              minWidth: 80,
              maxWidth: size.width
            ),
            margin: EdgeInsets.only(
              top: 2.0,
              bottom: 2.0,
              left: message.sentBy == myUserID ? size.width * 0.15 : 8.0,
              right: message.sentBy == myUserID ? 8.0 : size.width * 0.15,
            ),

            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(18.0)),

              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                
                child: Padding(
                  padding: EdgeInsets.all(6.0),

                  child: Stack(
                    children: [
                      //MESSAGE
                      Padding(
                        padding: const EdgeInsets.only(bottom : 15.0),
                        
                        child: message.message.contains('https://firebasestorage.googleapis.com/v0/b/to-home-1416d.appspot.com') ?
                          //IMAGE MESSAGE
                          GestureDetector(
                            onTap: (){
                              MessageAppAlertDialogs().messageAppShowUserImage(
                                message.message
                              );
                            },
                            child: Imagee().imageMessage(message.message)
                          )
                          :
                          //TEXT MESSAGE
                          Teexts().label(
                            message.message, 
                            17.0, 
                            Colors.black
                          ),
                      ),

                        SizedBox(height: 4.0),

                      //DATE
                      Positioned(
                        bottom: 0.0,
                        right: 0.0,

                        child: Teexts().label(message.hour, 
                          11.0, 
                          Colors.black
                        )
                      ),
                      
                    ],
                  ),
                ),
              ),
            )
          ),
        ),
      ],
    );
  }


  Widget dateWidget(String date){
    return Column(
      mainAxisSize: MainAxisSize.min,

      children: [
        Container(
          margin: EdgeInsets.all(10.0),
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.blueGrey,
            borderRadius: BorderRadius.circular(10.0)
          ),

          child: Teexts().label(date, 16.0, Colors.white),
        ),
      ],
    );
  }

  
  Widget featuredMessageContainer({BuildContext context,FeaturedMessage message,double topBottomMargin}){
    Size size = MediaQuery.of(context).size;

    String dateFormat = DateFormat.yMd('es').format(
      DateTime.parse(message.date)
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: message.sentBy == myUserID ? 
        CrossAxisAlignment.end
        :
        CrossAxisAlignment.start,
      children: [
        Container(       
          decoration: BoxDecoration(
            border: Border.all(width: 4.0, color: Colors.amber),
            borderRadius: BorderRadius.all(Radius.circular(15.0))
          ),
          constraints: BoxConstraints(
              minWidth: 85,
              maxWidth: size.width
          ),
          padding: EdgeInsets.all(6.0),
          margin: EdgeInsets.only(
            top: topBottomMargin,
            bottom: topBottomMargin,
            left: message.sentBy == myUserID ? size.width * 0.15 : 8.0,
            right: message.sentBy == myUserID ? 8.0 : size.width * 0.15,
          ),

          child: Stack(
            children: [
              //MESSAGE
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 20.0
                ),
                child: Teexts().label(message.message, 19.0, Colors.black)
              ),

              //DATE
              Positioned(
                bottom: 0.0,
                right: 0.0,
                child: Teexts().label(dateFormat, 13.0, Colors.black)
              ),
              
            ],
          )
        ),
      ],
    );
  }


}
