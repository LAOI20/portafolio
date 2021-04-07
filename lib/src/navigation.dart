
import 'package:flutter/cupertino.dart';


final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();


class Nav {

  Future to(page){
    return Navigator.push(
      navigatorKey.currentContext,
      CupertinoPageRoute(
        builder: (context) => page
      )
    );
  }

  Future toUntil(page){
    return Navigator.pushAndRemoveUntil(
      navigatorKey.currentContext,      
      CupertinoPageRoute(
        builder: (context) => page,      
      ),
      (Route<dynamic> route) => false
    );
  }

  back(){
    return Navigator.pop(navigatorKey.currentContext);
  }

  Future toBackgroundTransparent(page){
    return Navigator.push(
      navigatorKey.currentContext,
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (_, __, ___) => page,
      ),
    );
  }

}
