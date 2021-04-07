import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:get/state_manager.dart';

import 'package:portafolio/src/navigation.dart';

import 'package:portafolio/src/welcomeApp/controllers/a-welcomeC.dart';

import 'package:portafolio/src/welcomeApp/pages/ab-loginFirebase.dart';

import 'package:portafolio/src/widgets/textfield.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class WelcomeAppWelcome extends StatelessWidget {
  const WelcomeAppWelcome({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GetBuilder<WelcomeAppWelcomeController>(
      init: WelcomeAppWelcomeController(),
      builder: (_){
      
        return Scaffold(
          backgroundColor: Colors.white,

          body: Center(

            child: Stack(
              children: [
                
                //BLUE CIRCLE TOP
                CirclesWelcome(
                  sizeContainer: size.height * 0.3,
                  color: Colors.blue[800],
                  top: -40.0,
                  left: - size.width * 0.05,
                  animation: _.pageAnimation,
                  beginAnimation: 0,
                  endAnimation: 0.25,
                ),

                //ORANGE CIRCLE TOP
                CirclesWelcome(
                  sizeContainer: size.height * 0.25,
                  color: Colors.orange,
                  top: -70.0,
                  left: 100.0,
                  animation: _.pageAnimation,
                  beginAnimation: 0.25,
                  endAnimation: 0.5,
                ),

                //ORANGE CIRCLE BOTTOM
                CirclesWelcome(
                  sizeContainer: 150.0,
                  color: Colors.orange,
                  bottom: -40.0,
                  right: -40.0,
                  animation: _.pageAnimation,
                  beginAnimation: 0.5,
                  endAnimation: 0.75,
                ),

                //BLUE CIRCLE BOTTOM
                CirclesWelcome(
                  sizeContainer: 100.0,
                  color: Colors.blue[800],
                  bottom: -70.0,
                  right: 50.0,
                  animation: _.pageAnimation,
                  beginAnimation: 0.75,
                  endAnimation: 1,
                ),
                
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [                    
                    Teexts().label('Iniciar sesion con', 25.0, Colors.black),

                    CardsBodyWelcome(
                      'Firebase', 
                      'https://firebasestorage.googleapis.com/v0/b/to-home-1416d.appspot.com/o/firebaseLogo.png?alt=media&token=dc89838b-def0-4c27-b033-7bbb6be318e1',

                      (){ 
                        Nav().to(WelcomeAppLoginFirebase());
                      }
                    ),

                    SizedBox(
                      height: 25.0,
                      
                      child: DefaultTextStyle(
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w700
                        ),

                        child: AnimatedTextKit(
                          animatedTexts: [
                            WavyAnimatedText(
                              "Angel Orozco",
                            ),
                            WavyAnimatedText(
                              "Contactame",
                            ),
                            WavyAnimatedText(
                              "3741078455",
                            ),
                          ]
                        ),
                      ),
                    ),

                  ],
                ),
              ],
            ),
          ),
        );
      }
    );
  }

}

class CirclesWelcome extends StatelessWidget {

  final double top;
  final double bottom;
  final double left;
  final double right;
  final double sizeContainer;
  final Color color;
  final double beginAnimation;
  final double endAnimation;
  final Animation animation;

  const CirclesWelcome({this.sizeContainer, this.color,this.top, this.bottom, this.left, this.right, this.beginAnimation, this.endAnimation, this.animation});

  @override
  Widget build(BuildContext context) {

    return Positioned(
      top: top,
      bottom: bottom,
      right: right,
      left: left,

      child: ScaleTransition(
        scale: CurvedAnimation(
          curve: Interval(
            beginAnimation,
            endAnimation,
            curve: Curves.bounceIn
          ),
          parent: animation
        ),

        child: Container(
          height: sizeContainer,
          width: sizeContainer,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.all(Radius.circular(150.0))
          ),
        ),
      ),
    );
  }
}

class CardsBodyWelcome extends StatelessWidget {

  final String text;
  final String imageUrl;
  final VoidCallback onTap;

  const CardsBodyWelcome(this.text, this.imageUrl,this.onTap);

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: onTap,

      child: Container(
        padding: EdgeInsets.all(10.0),
        
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Teexts().label(text, 20.0, Colors.black),

            Container(
              height: 70.0,
              width: 70.0,

              child: FadeInImage(
                fadeInDuration: Duration(seconds: 1),
                placeholder: AssetImage('images/loading.gif'),
                image: NetworkImage(imageUrl),
              )
            )
            
          ],
        ),
      ),
    );
  }
}