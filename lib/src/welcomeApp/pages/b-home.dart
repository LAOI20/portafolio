import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/state_manager.dart';
import 'package:animations/animations.dart';
import 'package:portafolio/src/services/myInfo.dart';

import 'package:portafolio/src/welcomeApp/controllers/b-homeC.dart';

import 'package:portafolio/src/welcomeApp/database/b-homeD.dart';

import 'package:portafolio/src/welcomeApp/widgets/alertDialogs.dart';
import 'package:portafolio/src/widgets/textfield.dart';

import 'package:flutter/material.dart';

class WelcomeAppHome extends StatefulWidget {
  const WelcomeAppHome({Key key}) : super(key: key);

  @override
  _WelcomeAppHomeState createState() => _WelcomeAppHomeState();
}

class _WelcomeAppHomeState extends State<WelcomeAppHome> with WidgetsBindingObserver{


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        WelcomeAppHomeDatabase().updateStatus(true);
        break;
      case AppLifecycleState.inactive:
        WelcomeAppHomeDatabase().updateStatus(false);
        break;
      case AppLifecycleState.paused:
        WelcomeAppHomeDatabase().updateStatus(false);      
        break;
      case AppLifecycleState.detached:
        WelcomeAppHomeDatabase().updateStatus(false);
        break;
    }
}

@override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {    
    return GetBuilder<WelcomeAppHomeController>(
      init: WelcomeAppHomeController(),
      builder: (_){
        return Scaffold(
          body: SafeArea(
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6.0),

                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: _.appsNames.length,
                    itemBuilder: (context, index){
                      return AppsBody(
                        index: index,
                        appName: _.appsNames[index],
                        initAnimation: () => _.initDescriptionAnimation(),
                      );
                    }
                  ),
                ),

                //ICONBUTTON SIGN OUT
                Positioned(
                  right: 10.0,
                  top: 5.0,
                  
                  child: IconButton(
                    icon: Icon(Icons.power_settings_new),
                    iconSize: 40.0,
                    color: Colors.red,
                    
                    onPressed: (){
                      WelcomeAppAlertDialogs().signOut(context);
                    }
                  ),
                )
              ],
            ),
          )
        );
      }
    );
  }
}

class AppsBody extends StatelessWidget {

  final int index;
  final String appName;
  final Function initAnimation;

  const AppsBody({this.appName, this.initAnimation, this.index});

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: EdgeInsets.only(
        bottom: 15.0,
        top: index == 0 ? 70.0 : 15
      ),

      child: Card(
        elevation: 10.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))
        ),
        child: Column(
          children: [
            //APP NAME AND ON TAP FOR NAVIGATION TO APP
            GestureDetector(
              onTap: (){
                WelcomeAppHomeController().navigationToApp(
                  context, appName
                ); 
              },

              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                decoration: BoxDecoration(
                  color: MyInfo.isDarkMode != true ?
                    Colors.blueAccent
                    :
                    Colors.black,
                  borderRadius: BorderRadius.all(Radius.circular(20.0))
                ),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Teexts().label(
                      appName, 
                      22.0, 
                      MyInfo.isDarkMode != true ?
                        Colors.black
                        :
                        Colors.white60
                    ),
                      
                    Icon(
                      Icons.arrow_forward_ios,                       
                      size: 30.0,
                      color: MyInfo.isDarkMode != true ?
                        Colors.black
                        :
                        Colors.white60
                    ), 
                     
                  ],
                ),
              ),
            ),

              SizedBox(height: 30.0),

            //SEE APP DESCRIPTION
            OpenContainer(
              closedElevation: 0,
              closedColor: Colors.transparent,
              openColor: MyInfo.isDarkMode == true ? 
                Colors.black 
                : 
                Colors.white,

              transitionDuration: Duration(milliseconds: 700),
              transitionType: ContainerTransitionType.fadeThrough,
              tappable: false,

              closedBuilder: (context, openWidget){
                return Align(
                  alignment: Alignment.bottomRight,

                  child: TextButton(
                    onPressed: (){
                      openWidget();
                      initAnimation();
                    },

                    child: Teexts().label(
                      'Ver descripcion', 
                      20.0, 
                      MyInfo.isDarkMode != true ?
                        Colors.blue
                        :
                        Colors.white60
                    )
                  )
                );
              },

              openBuilder: (context, closeWidget){
                return _AppDescriptionWidget(
                  appName: appName,
                );
              }
            ),
            
              SizedBox(height: 10.0),

          ],
        ),
      ),
    );
  }
}


class _AppDescriptionWidget extends StatelessWidget {

  final String appName;

  const _AppDescriptionWidget({Key key, this.appName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GetBuilder<WelcomeAppHomeController>(
      id: 'appDescriptionContainer',
      builder: (_){
        return Container(
          height: size.height,
          width: size.width,

          child: SafeArea(
            child: Column(
              children: [
                  SizedBox(height: 20.0),
                
                //INFO ICON
                ScaleTransition(
                  scale: CurvedAnimation(
                    curve: Interval(
                      0.1,
                      0.4,
                      curve: Curves.bounceOut
                    ),
                    parent: _.descriptionAnimation
                  ),

                  child: Icon(
                    FontAwesomeIcons.infoCircle,
                    color: Colors.blueGrey,
                    size: 100.0
                  ),
                ),

                  SizedBox(height: 20.0),

                //APP NAME
                ScaleTransition(
                  scale: CurvedAnimation(
                    curve: Interval(
                      0.3, 
                      0.6,
                      curve: Curves.elasticOut
                    ),
                    parent: _.descriptionAnimation
                  ),

                  child: Text(
                    appName,
                    style: TextStyle(
                      color: Colors.purple,
                      fontSize: 25.0,
                      fontWeight: FontWeight.w800
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                  SizedBox(height: 10.0,),

                //DESCRIPTION
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  
                  child: AnimatedText(
                    'Esta es una app de mensajeria con la cual puedes chatear con tus amigos, compartir fotos y subir estados para que todos tus amigos los puedan ver', 
                    CurvedAnimation(
                      curve: Interval(0.5, 1),
                      parent: _.descriptionAnimation
                    ),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 19.0
                    )
                  ),
                ),

                Spacer(),

                //BACK ICONBUTTON
                Align(
                  alignment: Alignment.bottomLeft,

                  child: ScaleTransition(
                    scale: CurvedAnimation(
                      curve: Interval(
                        0.7, 
                        1,
                        curve: Curves.elasticInOut
                      ),
                      parent: _.descriptionAnimation
                    ),

                    child: IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      color: Colors.blueGrey,
                      iconSize: 45.0,

                      onPressed: (){
                        _.resetDescriptionAnimation();
                        Navigator.pop(context);
                      }
                    ),
                  )
                )
              ]
            ),
          )
        );
      }
    );
  }
}


class AnimatedText extends StatefulWidget {
  final String text;

  final List<TextSpan> _slices;
  final List<TextSpan> _slicesTransparent;

  final Animation<double> progress;

  final TextAlign textAlign;
  final TextStyle style;

  AnimatedText(
    this.text,
    this.progress, {
    this.textAlign,
    this.style,
  })  : _slices = _generateSlices(text, style, false).toList(growable: false),
        _slicesTransparent =
            _generateSlices(text, style, true).toList(growable: false);

  static Iterable<TextSpan> _generateSlices(
      String text, TextStyle style, bool transparent) sync* {
    const step = 3;
    var i = 0;
    for (; i < text.length - step; i += step) {
      yield TextSpan(
        text: text.substring(i, i + step),
        style: transparent ? style.apply(color: Colors.transparent) : null,
      );
    }
    yield TextSpan(
      text: text.substring(i),
      style: transparent ? style.apply(color: Colors.transparent) : null,
    );
  }

  @override
  _AnimatedTextState createState() => _AnimatedTextState();
}

class _AnimatedTextState extends State<AnimatedText> {
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.progress,
      builder: (BuildContext context, Widget child) {
        return Text.rich(
          TextSpan(
            children: [
              for (var i = 0; i < widget._slices.length; i++)
                (i / widget._slices.length < widget.progress.value)
                    ? widget._slices[i]
                    : widget._slicesTransparent[i],
            ],
          ),
          textAlign: widget.textAlign,
          style: widget.style,
        );
      },
    );
  }
}