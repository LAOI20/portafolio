import 'dart:ui';
import 'package:portafolio/src/services/myInfo.dart';
import 'package:get/state_manager.dart';

import 'package:portafolio/src/navigation.dart';

import 'package:portafolio/src/messagesApp/controllers/a-chatListC.dart';

import 'package:portafolio/src/messagesApp/models/a-chatListM.dart';

import 'package:portafolio/src/messagesApp/pages/ac-stories.dart';
import 'package:portafolio/src/messagesApp/pages/ad-drawerChatList.dart';

import 'package:portafolio/src/messagesApp/widgets/alertDialogs.dart';

import 'package:portafolio/src/widgets/backgroundImage.dart';
import 'package:portafolio/src/widgets/imagee.dart';
import 'package:portafolio/src/widgets/textfield.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class MessageAppChatList extends StatelessWidget {
  const MessageAppChatList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {  
    Size size = MediaQuery.of(context).size;

    return GetBuilder<MessageAppChatListController>(
      init: MessageAppChatListController(),
      builder: (_){
        return Scaffold(      
          body: backgroundImage(
            child: Stack(
              children: [            

                _ConversationsContainer(),

                _AppBarContainer(),

                //STORIES BUTTON
                Padding(
                  padding: EdgeInsets.only(top: size.height * 0.08),

                  child: Align(
                    alignment: Alignment.topCenter,

                    child: _StoriesContainerAnimated(
                      animation: _.storiesContainerAC,
                    ),
                  )
                )

              ],
            ),
          ),

          floatingActionButton: FloatingActionButton(
            backgroundColor: MyInfo.isDarkMode != true ?
              Colors.purple
              :
              Colors.black,

            onPressed: (){ 
              Nav().toBackgroundTransparent(MessageAppDrawerChatList());
            },

            child: Icon(
              Icons.list, 
              size: 40.0,
              color: MyInfo.isDarkMode != true ?
                Colors.black : Colors.white60
            ),
          )
          
        );
      },
    );
  }
}


class _AppBarContainer extends StatelessWidget {
  const _AppBarContainer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.12,
      width: size.width,
      decoration: BoxDecoration(
        color: MyInfo.isDarkMode != true ?
          Colors.blueGrey : Colors.black54,

        borderRadius: BorderRadius.vertical(bottom: Radius.circular(50.0))
      ),
    );
  }
}


class _StoriesContainerAnimated extends StatelessWidget {

  final AnimationController animation;

  const _StoriesContainerAnimated({Key key, this.animation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, __) {
        return GestureDetector(
          onTap: (){ Nav().to(MessageAppStories()); },

          child: Container(
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  MyInfo.isDarkMode != true ? 
                    Colors.purple : Colors.black,

                  MyInfo.isDarkMode != true ?
                    Colors.purple[100] : Colors.white60,

                  MyInfo.isDarkMode != true ?
                    Colors.blueGrey : Colors.black87
                ],
                stops: [
                  0.0,
                  animation.value,
                  1.0
                ]
              )
            ),

            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Teexts().label(
                  'Estados', 
                  25.0, 
                  MyInfo.isDarkMode != true ?
                    Colors.white : Colors.white60
                ),

                Icon(
                  Icons.arrow_right_sharp, 
                  size: 40.0, 
                  color: MyInfo.isDarkMode != true ?
                   Colors.white : Colors.white60
                )
              ],
            ),
          ),
        );
      }
    );
  }
}


class _ConversationsContainer extends StatelessWidget {
  
  const _ConversationsContainer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GetBuilder<MessageAppChatListController>(
      id: 'conversationsContainer',
      builder: (_) {      
        return Container(
          height: size.height,
          width: size.width,

          child: StreamBuilder( 
            stream: _.conversationsStream,
            builder: (context, snapshot) {             
         
              if(snapshot.data == null) return Center(child: CircularProgressIndicator());
              
              return ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: snapshot.data.length,
                itemBuilder: (context, index){

                  ViewConversation conversation = snapshot.data[index];
                  
                  return Padding(
                    padding: EdgeInsets.only(
                      top: index == 0 ? size.height * 0.22 : 5.0,
                      bottom: index == snapshot.data.length - 1 ? 
                        size.height * 0.12 
                        : 
                        5.0
                    ),

                    child: _CardConversation(
                      conversation: conversation,
                      streamFriendOnline: _.streamfriendOnline(conversation.friendID)
                    ),
                  );
                }
              );
            }            
          ),
        );
      }
    );
  }
  
}


class _CardConversation extends StatelessWidget {

  final ViewConversation conversation;
  final Stream<SimpleUser> streamFriendOnline;

  const _CardConversation({Key key, this.conversation, this.streamFriendOnline}) : super(key: key);

  @override
  Widget build(BuildContext context) {
 
    return StreamBuilder(
      stream: streamFriendOnline,
      builder: (context, snapshot) {
        
        if(snapshot.data == null) return Center(child: CircularProgressIndicator());

        SimpleUser friend = snapshot.data;

        return GestureDetector(
          onTap: (){
            FocusScope.of(context).unfocus();

            MessageAppChatListController().navigationToChatFriend(
              context, conversation, friend
            );
          },

          child: Padding(
            padding: EdgeInsets.all(5.0),

            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),

              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),

                child: Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: friend.online == true ? Colors.green[500] : Colors.black,
                      width: 5.0
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20.0))
                  ),
                  
                  child: Row(
                    children: [

                      //PROFILE PICTURE
                      GestureDetector(
                        onTap: (){ 
                          FocusScope.of(context).unfocus();

                          MessageAppAlertDialogs().messageAppShowUserImage(
                            friend.photoUrl
                          ); 
                        },

                        child: Imagee().imageContainer(
                          size: 70.0, imageUrl: friend.photoUrl
                        )
                      ),

                        SizedBox(width: 8.0),

                      //USER NAME AND DATE LAST MESSAGE AND LAST MESSAGE
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //FRIEND NAME AND DATE LAST MESSAGE
                            Row(
                              children: [
                                Expanded(
                                  child: Teexts().labelExpanded(
                                    text: friend.name,
                                    color: Colors.black,
                                    fontSize: 20.0,
                                    maxLines: 1
                                  )
                                ),

                                Teexts().label(
                                  conversation.dateLastMessage, 
                                  13.0, 
                                  Colors.black
                                )
                              ],
                            ),
                            
                            //LAST MESSAGE AND COUNT LAST MESSAGES
                            Row(
                              children: [
                                Expanded(
                                  child: Teexts().labelExpanded(
                                    text: conversation.writingFriend == true ? 
                                      'escribiendo...'
                                      : 
                                      conversation.lastMessage.contains('https://firebasestorage.googleapis.com/v0/b/to-home-1416d.appspot.com') ?
                                        '📷'
                                        :
                                        conversation.lastMessage,
                                    
                                    color: conversation.writingFriend == true ?
                                      Colors.green[500]
                                      :
                                      Colors.black,

                                    fontSize: 16.0,
                                    maxLines: 2
                                  )
                                ),

                                conversation.countLastMessages == 0 ?
                                  SizedBox(width: 0.0)
                                  :
                                  Container(
                                    padding: EdgeInsets.all(5.0),
                                    decoration: BoxDecoration(
                                      color: Colors.blue,
                                      shape: BoxShape.circle
                                    ),

                                    child: Teexts().label(
                                      conversation.countLastMessages.toString(), 
                                      16.0, 
                                      Colors.white
                                    )
                                  )
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}


