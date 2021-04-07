import 'dart:io';
import 'package:get/state_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:story_view/story_view.dart';

import 'package:portafolio/src/navigation.dart';

import 'package:portafolio/src/messagesApp/models/ac-storiesM.dart';

import 'package:portafolio/src/messagesApp/database/ac-storiesD.dart';

import 'package:portafolio/src/messagesApp/pages/aca-addToMyStories.dart';

import 'package:portafolio/src/messagesApp/widgets/cupertino.dart';
import 'package:portafolio/src/widgets/imagee.dart';
import 'package:portafolio/src/widgets/textfield.dart';

import 'package:flutter/material.dart';

class MessageAppStoriesController extends GetxController {
  

  List<String> friendsIDS = [];

  final StoryController storyViewcontroller = StoryController();
  List<StoryItem> storiess = [];


  Stream<MyStoriesInfo> streamMyDateLastStory = 
  MessageAppStoriesDatabase().streamMyStoriesInfo();


  Stream<List<FriendInfoStory>> streamfriendsInfoStory = MessageAppStoriesDatabase().streamFriendsInfoStories();

  
  void showCupertinoActions(BuildContext context){
    MessageAppCupertino().showCupertinoActions(
      context: context,
      onTapTakePhoto: () => loadedPhoto(false),
      onTapSelectPhoto: () => loadedPhoto(true),
    );
  }

  //TAKE OR SELECT PHOTO AND NAVIGATION TO PAGE WITH IMAGE
  //AND ADD COMMENTARY
  void loadedPhoto(bool fromGallery) async{
    try {      
      File fileImage;
      final image = await ImagePicker().getImage(
        source: fromGallery == true ?
          ImageSource.gallery
          :
          ImageSource.camera
      );
      fileImage = File(image.path);

      Nav().back();
      Nav().to(MessageAppAddToMyStories(imageFile: fileImage));
      
    } catch (e) {
      print('ERRRRORRR $e');
      
    }
  }

  
  
  void getStories(String userName,String friendID){
    MessageAppStoriesDatabase().getStories(friendID).then((value){
      storiess = value.map((e) =>
        StoryItem(
          Container(
            color: Colors.black,

            child: Stack(
              children: [

                //USER NAME AND STORY DATE
                Column(
                  children: [
                    //USER NAME
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(top: 50.0),
                      padding: EdgeInsets.all(10.0),                  

                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Teexts().label(userName, 22.0, Colors.blueGrey),

                          Teexts().label(e.date, 16.0, Colors.blueGrey),
                        ],
                      )
                    ),

                    //IMAGE
                    Expanded(
                      child: Imagee().squareImage(e.imageUrl),
                    ),
                  ],
                ),

                //IMAGE TEXT
                Align(
                  alignment: Alignment.bottomCenter,

                  child: Padding(
                    padding: const EdgeInsets.only(
                      bottom: 10.0,
                      left: 4.0,
                      right: 4.0
                    ),

                    child: Text(
                      e.text,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 19.0
                      ),
                      textAlign: TextAlign.center,
                    )
                  ),
                )
              ],
            ),
          ),
          
          duration: Duration(seconds: 3)
        )
      ).toList();
      
      update(['seeStoriesContainer']);
    });
  }

  void exitSeenStories(){
    storiess.clear();    
  }

}