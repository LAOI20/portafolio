import 'dart:ui';
import 'package:grouped_list/grouped_list.dart';
import 'package:portafolio/src/services/formatDate.dart';
import 'package:portafolio/src/services/myInfo.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/state_manager.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

import 'package:portafolio/src/navigation.dart';

import 'package:portafolio/src/messagesApp/database/aa-chatScreenD.dart';

import 'package:portafolio/src/messagesApp/models/aa-chatScreenM.dart';

import 'package:portafolio/src/messagesApp/controllers/aa-chatScreenC.dart';

import 'package:portafolio/src/messagesApp/pages/aaa-friendProfile.dart';

import 'package:portafolio/src/messagesApp/widgets/messageContainer.dart';
import 'package:portafolio/src/widgets/backgroundImage.dart';
import 'package:portafolio/src/widgets/loadings.dart';
import 'package:portafolio/src/widgets/textfield.dart';

import 'package:flutter/material.dart';


class MessageAppChatScreen extends StatelessWidget {

  const MessageAppChatScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MessageAppChatScreenController>(
      init: MessageAppChatScreenController(),
      builder: (_) {
        return Scaffold(
          backgroundColor: Colors.blueGrey,

          body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),

            child: Stack(
              children: [
                
                Column(
                  children: [
                    //BAR (FRIEND IMAGE - FRIEND NAME)
                    _AppBarAnimated(
                      friendID: _.friendREF.id,
                      friendName: _.friendREF.name,
                      friendPhotoUrl: _.friendREF.photoUrl,
                      animation: _.appBarContainerAC,
                      onTapVideoCall: () => _.makeVideoCall(),
                    ),

                      const SizedBox(height: 8.0),
                      
                    Expanded(
                      child: _ContainerMessages(),
                    )
                    //WHITE CONTAINER WITH MESSAGES LIST AND CONTAINER SEND MESSAGE
                    //_ContainerMessages(),
                  ],
                ),

                
                _.showLoadWidget == true ?
                  Loadings().loadWidgetFullScreen(context)
                  :
                  SizedBox(height: 0.0)
              ],
            ),
          ),
        );
      }
    );
  }

}


class _AppBarAnimated extends StatelessWidget {

  final AnimationController animation;
  final String friendID;
  final String friendName;
  final String friendPhotoUrl;
  final Function onTapVideoCall;

  const _AppBarAnimated({Key key, this.animation, this.friendPhotoUrl, this.friendName, this.friendID, this.onTapVideoCall}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(

      child: Padding(
        padding: const EdgeInsets.all(8.0),

        child: CustomPaint(
          painter: _CustomPainterAppBar(
            animation: animation,
            snakeColor: Colors.purple,
            borderColor: MyInfo.isDarkMode != true ? 
              Colors.white : Colors.black
          ),

          child: Container(
            width: size.width,

            child: GestureDetector(
              onTap: (){
                Nav().to(MessageAppFriendProfile());
              },

              child: Padding(
                padding: const EdgeInsets.all(10.0),

                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //FRIEND PHOTO
                    Container(
                      height: 55.0,
                      width: 55.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(friendPhotoUrl),
                          fit: BoxFit.cover
                        )
                      )
                    ),
                    
                      SizedBox(width: 10.0),
                    
                    //FRIEND NAME AND ONLINE STATUS
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Teexts().labelExpanded(
                            text: friendName,
                            color: Colors.white,
                            fontSize: 19.0,
                            maxLines: 1
                          ),

                          //GET STATUS FRIEND
                          StreamBuilder(
                            stream: MessageAppChatScreenDataBase().getStatusFriend(friendID),
                            builder: (context, snapshot){
                              //SNAPSHOT.DATA [0] IS STATUS ONLINE OF FRIEND
                              //SNAPSHOT.DATA [1] IS IF MY FRIEND IS WRITING
                              if(snapshot.data == null) return SizedBox(height: 0.0);

                              return snapshot.data[1] == true ?
                                Teexts().label('escribiendo...', 12.0, Colors.white)
                                :
                                snapshot.data[0] == true ?
                                  Teexts().label('en linea', 12.0, Colors.white)
                                  :
                                  SizedBox(height: 0.0);
                            },
                          )
                        ],
                      ),
                    ),

                    //ICONBUTTON VIDEO CALL
                    IconButton(
                      icon: Icon(Icons.videocam_outlined),
                      color: Colors.white,
                      iconSize: 35.0,
                      onPressed: onTapVideoCall
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class _CustomPainterAppBar extends CustomPainter {

  final Animation animation;
  final Color snakeColor;
  final Color borderColor;

  _CustomPainterAppBar({
    this.animation, this.snakeColor, this.borderColor,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()
      ..shader = SweepGradient(
        colors: [
          snakeColor,
          Colors.transparent
        ],
        startAngle: 0.0,
        endAngle: vector.radians(100),
        transform: GradientRotation(vector.radians(360 * animation.value))
      ).createShader(rect);
    
    final path = Path.combine(
      PathOperation.xor, 
      Path()..addRect(rect), 
      Path()..addRect(rect.deflate(6.0))
    );

    canvas.drawRect(
      rect.deflate(3.0),
      Paint()
        ..color = borderColor
        ..strokeWidth = 6.0
        ..style = PaintingStyle.stroke  
    );
    
    canvas.drawPath(path, paint);

    
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}



class _ContainerMessages extends StatelessWidget {
  const _ContainerMessages({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),

      child: backgroundImage(
        child: Column(
          children: [
            //MESSAGES LIST
            GetBuilder<MessageAppChatScreenController>(
              id: 'messagesListContainer',
              builder: (_) {
                //CHECK IF THE CONVERSATION EXISTS
                return _.friendREF.conversationID == 'not' ?
                  Spacer()
                  :
                  Expanded(
                    child: StreamBuilder(
                      stream: MessageAppChatScreenDataBase().messagesListStream(
                        _.friendREF.conversationID, _.friendREF.isUser1
                      ),
                      builder: (context, snapshot){

                        if(snapshot.data == null) return Center(child: CircularProgressIndicator());

                        return GroupedListView(
                          physics: BouncingScrollPhysics(),
                          elements: snapshot.data,
                          order: GroupedListOrder.DESC,
                          reverse: true,
                          floatingHeader: true,
                          useStickyGroupSeparators: true,
                          groupBy: (Messageee message) => message.ddmmyy,
                          groupHeaderBuilder: (Messageee message){
                            return MessageAppMessageContainer().dateWidget(
                              FormatDatee().formatPastDateMessages(
                                message.date, false
                              )
                            );
                          },
                          itemBuilder: (context, messagee){
                            return MessageAppMessageContainer().messageContainer(
                              context: context,
                              message: messagee,

                              //ON-LONG-PRESS MESSAGE CONTAINER
                              onLongPress: () => _.cupertinoActionAddFeaturedMessages(
                                context: context,
                                message: messagee
                              )
                            );
                          }
                        );
                      }
                    )
                  );
              }
            ),

              SizedBox(height: 8.0),

            //SEND MESSAGES
            _ContainerSendMessage()
          ],
        ),
      ),
    );
  }
}


class _ContainerSendMessage extends StatelessWidget {
  const _ContainerSendMessage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GetBuilder<MessageAppChatScreenController>(
      id: 'sendMessageContainer',
      builder: (_) {
        return Container(
          width: size.width,
          constraints: BoxConstraints(
            maxHeight: size.height * 0.25
          ),          

          child: ClipRRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                
                child: Row(
                  children: [
                    //TEXTFIELD 
                    Expanded(
                      child: Teexts().messageAppSendMessageTextField(
                        _.sendMessagetextFieldController, //controller
                        _.focoSendMessageTextfield, //focus
                        (text){ _.changeTextField(); } //on change 
                      )
                    ),

                    //ICONBUTTON
                    GetBuilder<MessageAppChatScreenController>(
                      id: 'iconTextField',
                      builder: (__){
                        return IconButton(
                          icon: __.sendMessagetextFieldController.text.trim().length == 0 ? 
                                  Icon(Icons.camera_alt, color: Colors.black)
                                  :
                                  Icon(FontAwesomeIcons.paperPlane, color: Colors.purple[900]),
                          iconSize: 35.0,
                          onPressed: (){
                            __.sendMessagetextFieldController.text.trim().length == 0 ?
                              __.showCupertinoActionsPhoto(context)
                              :
                              __.sendMessage(context);
                          },
                        );
                      }
                    )

                  ]
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}