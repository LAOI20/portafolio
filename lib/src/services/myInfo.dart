

class MyInfo {

  static String appNameSelect;

  static String myUserID;
  static String myName;
  static String myInfo;
  static String myEmail;
  static String myPhotoUrl;
  static String myToken;

  static FriendREF friendInfo;
  static String friendID;

  static String myPostalCode;

  static bool isDarkMode = false;
  
}

//GET DATA FROM PAGE A-CHAT-LIST
class FriendREF {
  String conversationID;
  String id;
  String token;
  bool isUser1;
  String name;
  String info;
  String photoUrl;

  FriendREF(
    this.conversationID,
    this.id,
    this.token,
    this.isUser1,
    this.name,
    this.info,
    this.photoUrl
  );

  FriendREF.fromData({String idConversation,String friendID,String friendToken,
                      bool heIsUser1,
                      String friendName,String infoFriend,
                      String urlPhoto
  }){

    conversationID = idConversation;
    id = friendID;
    token = friendToken;
    isUser1 = heIsUser1;
    name = friendName;
    info = infoFriend;
    photoUrl = urlPhoto;
    
  }

}