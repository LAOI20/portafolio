import 'package:animations/animations.dart';
import 'package:portafolio/src/services/myInfo.dart';
import 'package:get/state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:story_view/story_view.dart';

import 'package:portafolio/src/messagesApp/controllers/ac-storiesC.dart';

import 'package:portafolio/src/messagesApp/models/ac-storiesM.dart';

import 'package:portafolio/src/messagesApp/database/ac-storiesD.dart';

import 'package:portafolio/src/widgets/backgroundImage.dart';
import 'package:portafolio/src/widgets/buttons.dart';
import 'package:portafolio/src/widgets/imagee.dart';
import 'package:portafolio/src/widgets/loadings.dart';
import 'package:portafolio/src/widgets/textfield.dart';

import 'package:flutter/material.dart';


class MessageAppStories extends StatelessWidget {
  const MessageAppStories({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MessageAppStoriesController>(
      init: MessageAppStoriesController(),
      builder: (_) {
        return Scaffold(

          body: backgroundImage(
            child: SafeArea(
              child: CustomScrollView(
                physics: BouncingScrollPhysics(),
                
                slivers: [

                  //MY STORIE CONTAINER
                  SliverToBoxAdapter(
                    child: OpenContainer(
                      closedElevation: 0,
                      closedColor: Colors.transparent,
                      transitionDuration: Duration(milliseconds: 700),
                      transitionType: ContainerTransitionType.fadeThrough,
                      tappable: false,

                      closedBuilder: (context, opendWidget){
                        return _MyStoriesContainer(
                          seeMyStories: opendWidget,
                        );
                      },

                      openBuilder: (context, closeWidget){
                        return _PageSeeStories(
                          onTap: closeWidget,
                        ); 
                      }
                    )
                  ),

                  //LIST STORIES
                  SliverToBoxAdapter(
                    child: StreamBuilder(
                      stream: _.streamfriendsInfoStory,

                      builder: (context, snapshot){
                        if(snapshot.data == null) return Loadings().loadWidgetInBottomSheet();

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data.length,

                          itemBuilder: (context, index){

                            return OpenContainer(
                              closedElevation: 0,
                              closedColor: Colors.transparent,
                              transitionDuration: Duration(milliseconds: 700),
                              transitionType: ContainerTransitionType.fadeThrough,
                              tappable: false,

                              closedBuilder: (context, openWidget){
                                return _StoriesContainer( 
                                  index: index,
                                  infoStory: snapshot.data[index],
                                  onTapCard: openWidget,                               
                                );
                              },

                              openBuilder: (context, closeWidget){
                                return _PageSeeStories(
                                  onTap: closeWidget,
                                );
                              }
                            );
                          }
                        );
                      }
                    )
                  )
                ],
              ),
            ),
          )
        );
      }
    );
  }
}


class _MyStoriesContainer extends StatelessWidget {
 
  final Function seeMyStories;

  const _MyStoriesContainer({Key key, this.seeMyStories}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MessageAppStoriesController>();

    return Padding(
      padding: EdgeInsets.only(
        top: 10.0,
        bottom: 10.0,
        left: 5.0,
        right: 5.0
      ),

      child: GestureDetector(
        onTap: (){
          controller.getStories('Mis estados', MyInfo.myUserID);

          seeMyStories();
        },

        child: Card(
          elevation: 8.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))
          ),

          child: Padding(
            padding: EdgeInsets.all(8.0),

            child: Row(
              children: [
                Imagee().imageContainer(
                  size: 90.0, imageUrl: MyInfo.myPhotoUrl
                ),

                  SizedBox(width: 8.0),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Teexts().label(
                      'Mi estado', 
                      23.0, 
                      Colors.black
                    ),

                    StreamBuilder(
                      stream: controller.streamMyDateLastStory,

                      builder: (context, snapshot) {

                        if(snapshot.data == null) return Center(child: CircularProgressIndicator());

                        return Teexts().label(
                          snapshot.data.dateLastStory, 
                          16.0, 
                          Colors.black
                        );
                      }
                    )
                  ],
                ),

                Spacer(),

                Buttons().buttonIcon(
                  Icons.camera_alt, 
                  35.0, 
                  //ON TAP
                  () => controller.showCupertinoActions(context)
                )
              ]
            ),
          ),
        ),
      ),
    );
  }
}


class _StoriesContainer extends StatelessWidget {

  final int index;
  final FriendInfoStory infoStory;
  final Function onTapCard; //OPEN WIDGET

  const _StoriesContainer({this.onTapCard,this.index, this.infoStory});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MessageAppStoriesController>();

    bool storySeen;

    infoStory.storiesSeenBy.forEach((element) {
      if(element == MyInfo.myUserID){
        storySeen = true;
      }
    });

    return Padding(
      padding: EdgeInsets.only(
        top: 10.0,
        bottom: 10.0,
        left: 5.0,
        right: 5.0
      ),

      child: GestureDetector(
        onTap: (){
          MessageAppStoriesDatabase()
            .seeFriendStories(infoStory);

          controller.getStories(
            infoStory.friendName,
            infoStory.friendID
          );

          onTapCard();
        },

        child: Card(
          elevation: 8.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))
          ),

          child: Padding(
            padding: EdgeInsets.all(8.0),

            child: Row(
              children: [
                //FRIEND PHOTO AND ICON OF NEW STORIE
                Stack(
                  children: [
                    Imagee().imageContainer(
                      size: 70.0,
                      imageUrl: infoStory.friendPhotoUrl
                    ),

                    Positioned(
                      bottom: 0.0,
                      right: 0.0,

                      child: Container(
                        height: 23.0,
                        width: 23.0,
                        decoration: BoxDecoration(
                          color: storySeen == true ?
                            Colors.transparent
                            :
                            Colors.purple,

                          shape: BoxShape.circle
                        ),
                      ),
                    )
                  ],
                ),

                  SizedBox(width: 8.0),

                //FRIEND NAME AND DATE LAST STORY
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Teexts().label(
                      infoStory.friendName, 
                      23.0, 
                      Colors.black
                    ),
                    Teexts().label(infoStory.dateLastStory, 
                      16.0, 
                      Colors.black
                    )
                  ],
                ),
              ]
            ),
          ),
        ),
      ),
    );
  }
}


class _PageSeeStories extends StatelessWidget {

  final Function onTap;

  const _PageSeeStories({Key key,this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GetBuilder<MessageAppStoriesController>(
      id: 'seeStoriesContainer',
      builder: (_) {
        return WillPopScope(
          onWillPop: (){
            _.exitSeenStories();
            return Future.value(true);
          },

          child: Scaffold(
            body: Container(
              height: size.height,
              width: size.width,
              
              child: _.storiess.length == 0 ?
                Loadings().circularLoaded()
                :
                StoryView(
                  storyItems: _.storiess, 
                  controller: _.storyViewcontroller,

                  onComplete: (){
                    _.exitSeenStories();
                    onTap();
                  },
                  onStoryShow: (story){

                  },
                  onVerticalSwipeComplete: (direction){
                    if(direction == Direction.down ||
                       direction == Direction.up
                    ){
                      _.exitSeenStories();
                      onTap();
                    }
                  },
                )
            ),
          ),
        );
      }
    );
  }
}