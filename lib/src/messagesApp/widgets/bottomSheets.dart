import 'package:get/state_manager.dart';

import 'package:portafolio/src/messagesApp/controllers/aaa-friendProfileC.dart';

import 'package:portafolio/src/messagesApp/models/aaa-friendProfileM.dart';

import 'package:portafolio/src/messagesApp/widgets/alertDialogs.dart';
import 'package:portafolio/src/messagesApp/widgets/messageContainer.dart';
import 'package:portafolio/src/widgets/bottomSheetModel.dart';
import 'package:portafolio/src/widgets/imagee.dart';
import 'package:portafolio/src/widgets/loadings.dart';
import 'package:portafolio/src/widgets/textfield.dart';

import 'package:flutter/material.dart';

class MessageAppBottomSheets {


  //USE IN PAGE AAA-FRIEND-PROFILE
  messageAppShowFriendsCommonOrMutimedia({BuildContext context,String title,bool showFriends}){
    return BottomSheetModel().bottomSheet(
      context: context,
      builder: (context, scrollController){
        return BottomSheetModel().columnAndTitle(
          title: title,

          child: GetBuilder<MessageAppFriendProfileController>( 
            id: 'FriendsOrFilesBottomSheet',     
            builder: (_) {
              
              bool loadedData;
              
              if(showFriends == true){
                loadedData = _.loadedFriendsCommon;
              } else {
                loadedData = _.loadedSharedFiles;
              }

              return loadedData == null ?
                Loadings().circularLoaded()
                :
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),

                  child: GridView.builder(
                    controller: scrollController,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 10.0,
                      crossAxisSpacing: 10.0
                    ), 
                    itemCount: showFriends == true ? _.friendsCommonResult.length : _.shareddFiless.length,
                    itemBuilder: (context, index){

                      return GestureDetector(
                        onTap: (){
                          if(showFriends == true){
                            MessageAppAlertDialogs().messageAppShowUserImage(
                              _.friendsCommonResult[index].photoUrl
                            );
                          } else {
                            MessageAppAlertDialogs().messageAppShowUserImage(
                              _.shareddFiless[index].path
                            );
                          }
                        },

                        child: Container(

                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //SHOW FRIEND PHOTO OR FILE
                              showFriends == true ?  
                                Imagee().imageContainer(
                                  size: 70.0,
                                  imageUrl: _.friendsCommonResult[index].photoUrl
                                )

                                :

                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(_.shareddFiless[index].path),
                                        fit: BoxFit.cover
                                      )
                                    ),
                                  ),
                                ),

                              //SHOW FRIEND NAME OR FILE DATE
                              showFriends == true ? 
                                Text(
                                  _.friendsCommonResult[index].name,

                                  style: TextStyle(fontSize: 20.0),
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: false,
                                  maxLines: 1,
                                )
                                :
                                Teexts().label(_.shareddFiless[index].date, 16.0, Colors.black)
                            ],
                          ),
                        ),
                      );
                    }
                  ),
                );
            }
          ),
        );
      }
    );
  }


  //USE IN PAGE AAA-FRIEND-PROFILE
  messageAppShowFeaturedMessages(BuildContext context){
    return BottomSheetModel().bottomSheet(
      context: context,
      builder: (context, scrollController){
        return BottomSheetModel().columnAndTitle(
          title: 'Destacados',

          child: GetBuilder<MessageAppFriendProfileController>(
            id: 'FeaturedMessagesBottomSheet',
            builder: (_) {
              return _.loadedFeaturedMessages == null ?
                Loadings().circularLoaded()
                :
                ListView.builder(
                  reverse: true,
                  itemCount: _.featuredMessagesList.length,
                  itemBuilder: (context, index){   
                    
                    FeaturedMessage previousMessage = index == _.featuredMessagesList.length - 1 ?
                      _.featuredMessagesList[index - 1]
                      :
                      _.featuredMessagesList[index + 1];

                    return MessageAppMessageContainer().featuredMessageContainer(
                      context: context,
                      message: _.featuredMessagesList[index],
                      
                      topBottomMargin: 
                        _.featuredMessagesList[index].sentBy == previousMessage.sentBy ?
                          2.0
                          :
                          10.0
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