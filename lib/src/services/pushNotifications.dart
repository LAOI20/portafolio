
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:agora_rtc_engine/rtc_engine.dart' as agora;
import 'package:another_flushbar/flushbar.dart';
import 'package:audioplayer/audioplayer.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/instance_manager.dart';

import 'package:portafolio/src/services/myInfo.dart';
import 'package:portafolio/src/navigation.dart';
import 'package:portafolio/src/services/APImodel.dart';

import 'package:portafolio/src/messagesApp/controllers/ad-drawerChatListC.dart';

import 'package:portafolio/src/messagesApp/models/ad-drawerChatListM.dart';

import 'package:portafolio/src/messagesApp/pages/a-chatList.dart';
import 'package:portafolio/src/messagesApp/pages/aa-chatScreen.dart';
import 'package:portafolio/src/messagesApp/pages/ad-drawerChatList.dart';
import 'package:portafolio/src/welcomeApp/pages/b-home.dart';

import 'package:portafolio/src/services/pageVideoCall.dart';

import 'package:portafolio/src/widgets/alertMessage.dart';
import 'package:portafolio/src/widgets/imagee.dart';
import 'package:portafolio/src/widgets/textfield.dart';

import 'package:flutter/material.dart';


FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();  


Future<void> onBackgroundMessage(RemoteMessage info) async{
  if(info.data['type'] == 'videoCall'){
    print('entrooooooooo');
    showNotificationCall(info.data);
    //return PushNotications().showNotificationCall(info.data);
  }
}


 //NOTIFICATION VIDEO CALL
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final http.Response response = await http.get(Uri.parse(url));
    final File file = File(filePath);
    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }
  
  void showNotificationCall(Map<String, dynamic> notificationData) async{
    print('llamada entrooooo');
    final String bigPicturePath = await _downloadAndSaveFile(
      notificationData['userPhotoUrl'], notificationData['userName']
    );

    Timer(Duration(seconds: 15), (){
      flutterLocalNotificationsPlugin.cancelAll();
    });

    AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(
        'channelId', 'channelName', 'channelDescription',
        sound: RawResourceAndroidNotificationSound('sound'),
        priority: Priority.max,
        importance: Importance.max,
        fullScreenIntent: true,
        visibility: NotificationVisibility.public,
        largeIcon: FilePathAndroidBitmap(bigPicturePath),
        styleInformation: BigPictureStyleInformation(
          FilePathAndroidBitmap(bigPicturePath),
          contentTitle: 'VIDEO LLAMADA',
          htmlFormatTitle: true,
          summaryText: "${notificationData['userName']}. Toca para contestar",
          htmlFormatSummaryText: true
        )
      );

    flutterLocalNotificationsPlugin.show(
      0, 
      notificationData['title'], 
      notificationData['body'],     
      NotificationDetails(
        android: androidNotificationDetails
      ),
      payload: json.encode(notificationData)
    );    
  }

  void onTapNotificationCall(Map<String, dynamic> notificationData){
    Nav().to(_PageIncomingCall(
      userToken: notificationData['userToken'],
      userName: notificationData['userName'],
      userPhotoUrl: notificationData['userPhotoUrl'],
      callChannelName: notificationData['channelName'],
      callToken: notificationData['callToken'],
    ));
  }
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


class PushNotications {
  

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  initNotifications() async{  
    //PUSH NOTIFICATIONS  
    
    await _firebaseMessaging.requestPermission();

    _firebaseMessaging.getToken().then((token){      
      MyInfo.myToken = token;  
    });
    
    //LOCAL NOTIFICATIONS
    const AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings('app_icon');
    final InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings
    );

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (payload) async{
        final Map notificationData = await json.decode(payload);
        
        Nav().to(PageVideoCall(
          friendToken: notificationData['userToken'],
          channelName: notificationData['channelName'],
          iInitCall: false,
          role: agora.ClientRole.Broadcaster,
          token: notificationData['callToken'],
        ));
      }
    );
    


    //APP OPEN
    FirebaseMessaging.onMessage.listen((RemoteMessage info) {
      
      if(info.data['type'] == 'videoCall'){      
        onTapNotificationCall(info.data);    
          
      } else if(info.data['type'] == 'declinedCall'){
        Nav().back();
        AlertMessage().alertaMensaje('Llamada Rechazada');
      
      } else if(info.data['type'] == 'userEndedCall'){
        Nav().back();
        AlertMessage().alertaMensaje(info.notification.body);

      } else if(info.data['type'] == 'message' &&
                info.data['friendID'] == MyInfo.friendID
      ){       
        debugPrint("nadaaaa");
      } else {

        Flushbar(
          titleText: Text(
            info.notification.title,

            style: TextStyle(
              color: Colors.white,
              fontSize: 17.0,
              fontWeight: FontWeight.w700
            ),
          ),
          messageText: Text(
            info.notification.body,

            style: TextStyle(
              color: Colors.white,
              fontSize: 15.0
            ),
            overflow: TextOverflow.ellipsis,
            softWrap: false,
            maxLines: 2,
          ),
          flushbarPosition: FlushbarPosition.TOP,
          flushbarStyle: FlushbarStyle.FLOATING,
          duration: Duration(seconds: 4),
          margin: EdgeInsets.all(6.0),
          borderRadius: BorderRadius.all(Radius.circular(20.0)),

          onTap: (bar){
            onTapNotificationBackground(info);
          }

        )..show(navigatorKey.currentContext);

      }
    });

    //APP BACKGROUND
    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);    

    //ON TAP NOTIFICATION IN BACKGROUND
    FirebaseMessaging.onMessageOpenedApp.listen((info) {
      onTapNotificationBackground(info);
    });

    //APP TERMINATED
    _firebaseMessaging.getInitialMessage().then((info){
      onTapNotificationBackground(info);
    });
    
  }




  void onTapNotificationBackground(RemoteMessage info){
    
    if(info != null){
      if(info.data['type'] == 'message'){
        onTapNotificationMessage(info.data);
      } else if(info.data['type'] == 'FriendRequest'){
        onTapNotificationFriendRequest(false, info.data);
      } else if(info.data['type'] == 'AcceptRequest'){
        onTapNotificationFriendRequest(true, info.data);
      } else if(info.data['type'] == 'videoCall'){
        onTapNotificationCall(info.data);
      }
    }
  }


  //USE IN MESSAGES APP
  void sendNotificationMessage({
      String to,String title,String body,String sound,
      Map<String,dynamic> data
  }){
    APImodel().notificationsAPI(
      to: to,
      title: title,
      body: body,
      sound: sound,
      data: data
    );
  }

  void sendNotificationVideoCall({String to, dynamic data}){
    APImodel().notificationVideoCallAPI(
      to: to, data: data
    );
  }



  void onTapNotificationMessage(Map<String, dynamic> notificationData){

    MyInfo.appNameSelect = 'Mensajeria';
 
    MyInfo.friendInfo = FriendREF.fromData(
      idConversation: notificationData['conversationID'],
      friendID: notificationData['friendID'],
      friendToken: notificationData['friendToken'],
      heIsUser1: notificationData['isUser1'] == 'true' ? true : false,
      friendName: notificationData['name'],
      infoFriend: notificationData['info'],
      urlPhoto: notificationData['photoUrl']
    );

    MyInfo.friendID = notificationData['friendID'];


    Nav().toUntil(WelcomeAppHome());
    Nav().to(MessageAppChatList());
    Nav().to(MessageAppChatScreen());

  }

  void onTapNotificationFriendRequest(bool seeAcceptRequest,
                                      Map<String, dynamic> notificationData
  ){
    final drawerListController = Get.put(MessageAppDrawerChatListController());
    
    MyInfo.appNameSelect = 'Mensajeria';

    Nav().toUntil(WelcomeAppHome());
    Nav().to(MessageAppChatList());
    Nav().toBackgroundTransparent(MessageAppDrawerChatList());
    

    if(seeAcceptRequest == true){
      UserInfo user = UserInfo(
        notificationData['friendID'], 
        notificationData['friendName'], 
        notificationData['friendInfo'], 
        notificationData['friendEmail'], 
        notificationData['friendPhotoUrl'], 
        notificationData['friendToken'],         
      );

      drawerListController.onTapChangeView(2);
      drawerListController.seeFriendProfile(user);

    } else {
      drawerListController.onTapChangeView(3);
    }

  }

}










class _PageIncomingCall extends StatefulWidget {

  final String userToken;
  final String userName; //USER MADE CALL
  final String userPhotoUrl;
  final String callChannelName;
  final String callToken;

  const _PageIncomingCall({Key key, this.userName, this.userPhotoUrl, this.callChannelName, this.callToken, this.userToken}) : super(key: key);

  @override
  __PageIncomingCallState createState() => __PageIncomingCallState();
}

class __PageIncomingCallState extends State<_PageIncomingCall> {
  
  AudioPlayer audioPlayer;


  @override
  void initState() {
    super.initState();

    audioPlayer = AudioPlayer();

    audioPlayer.onPlayerStateChanged.listen((event) {
      if(event == AudioPlayerState.COMPLETED){
        Nav().back();
      }
    });

    audioPlayer.play('https://firebasestorage.googleapis.com/v0/b/to-home-1416d.appspot.com/o/sound.mp3?alt=media&token=9defe5d6-4bc9-453e-8de8-f2259c573503');  
  }

  @override
  void dispose() {
    print('dispose incoming call');
    audioPlayer.stop();

    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),

      child: Scaffold(
        backgroundColor: Colors.black,

        body: SafeArea(
          child: Column(
            children: [
              Teexts().label(
                'Videollamada', 
                30.0, 
                Colors.white,
                fontWeight: FontWeight.w800
              ),

                const SizedBox(height: 50.0,),
              
              Teexts().label(widget.userName, 25.0, Colors.white),

                const SizedBox(height: 10.0,),
              
              Imagee().imageContainer(
                size: 150.0, imageUrl: widget.userPhotoUrl
              ),

              Spacer(),
            
              //ICONBUTTONS ACCEPT CALL OR CANCEL
              Padding(
                padding: const EdgeInsets.only(
                  bottom: 10.0,
                  left: 20.0,
                  right: 20.0
                ),

                child: Row(
                  children: [
                    //DECLINED CALL
                    IconButton(
                      icon: Icon(Icons.call_end),
                      color: Colors.red[600],
                      iconSize: 50.0,

                      onPressed: (){
                        Nav().back();
                        declinedCall();
                      }
                    ),

                    Spacer(),

                    //ACCEPT CALL
                    IconButton(
                      icon: Icon(Icons.call),
                      color: Colors.green[600],
                      iconSize: 50.0,

                      onPressed: (){
                        Nav().back();
                        Nav().to(PageVideoCall(
                          friendToken: widget.userToken,
                          channelName: widget.callChannelName,
                          role: agora.ClientRole.Broadcaster,
                          token: widget.callToken,
                          iInitCall: false,
                        ));
                      }
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }


  void declinedCall(){
    APImodel().notificationsAPI(
      to: widget.userToken,
      title: widget.userName,
      body: 'Llamada Rechazada',
      data: {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        'type': "declinedCall",
      }
    );
  }
  
}