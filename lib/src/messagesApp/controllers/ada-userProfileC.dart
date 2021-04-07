import 'package:portafolio/src/services/myInfo.dart';
import 'package:portafolio/src/services/pushNotifications.dart';
import 'package:get/state_manager.dart';

import 'package:portafolio/src/messagesApp/database/ada-userProfileD.dart';

import 'package:portafolio/src/messagesApp/models/ad-drawerChatListM.dart';

import 'package:portafolio/src/widgets/alertMessage.dart';


class MessageAppUserProfileController extends GetxController {

  //INFO OF USER
  static UserInfo userInfoo;

  bool loadedData;

  bool requestSent;


  @override
  void onInit() {    
    super.onInit();

    //TO KNOW IF THE REQUEST HAS ALREADY BEEN SENT
    MessageAppUserProfileDataBase().getFriendRequest(userInfoo.id)
      .then((sent){
        loadedData = true;
        requestSent = sent;
        update();
      });
  }




  void sendRequestToUser(){
    MessageAppUserProfileDataBase().sendRequest(userInfoo.id);

    AlertMessage().alertaMensaje('Solicitud Enviada');

    requestSent = true;

    update();
    print(userInfoo.token);
    PushNotications().sendNotificationMessage(
      to: userInfoo.token,
      title: 'Solicitud de amistad',
      body: '${MyInfo.myName} quiere ser tu amigo',
      data: {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        'type': 'FriendRequest',
      }
    ); 
  }

}