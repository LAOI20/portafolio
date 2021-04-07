import 'package:rive/rive.dart';

import 'package:portafolio/src/navigation.dart';

import 'package:portafolio/src/welcomeApp/pages/0-onboarding.dart';
import 'package:portafolio/src/welcomeApp/pages/b-home.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplasScreen extends StatefulWidget {

  final bool isLogged;

  SplasScreen({Key key, this.isLogged}) : super(key: key);

  @override
  _SplasScreenState createState() => _SplasScreenState();
}

class _SplasScreenState extends State<SplasScreen> {

  Artboard _riveArtboard;
  RiveAnimationController _controller;

  @override
  void initState() {
    super.initState();

    rootBundle.load('images/splashscreen.riv').then(
      (data) async {
        final file = RiveFile();

        if (file.import(data)) {
          final artboard = file.mainArtboard;

          artboard.addController(_controller = SimpleAnimation('animation'));

          setState(() => _riveArtboard = artboard);
        }

      },
    ).then((value){
      _controller.isActiveChanged.addListener(() {
        if (_controller.isActive) {
          print('Animation started playing');
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            navigationToPage();
          });
        }
      });
    });

    
  }


  @override
  Widget build(BuildContext context) {  
    return Scaffold(
      backgroundColor: Colors.black,
      
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,

        child:  _riveArtboard == null? 
          const SizedBox()
          : 
          Rive(
            artboard: _riveArtboard,
            fit: BoxFit.fill,
          ),
      )
    );
  }


  void navigationToPage(){
    if(widget.isLogged == true){
      Nav().toUntil(WelcomeAppHome());
    } else {
      Nav().toUntil(WelcomeAppOnboardingPage());
    }
  }

}