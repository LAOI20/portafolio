import 'package:animated_text_kit/animated_text_kit.dart';

import 'package:portafolio/src/widgets/textfield.dart';

import 'package:flutter/material.dart';

class WelcomeAppOnboardingWidget {

  Widget pagesBody({List<String> animatedTitles,String description,
                    Color color
  }){
    return Container(
      color: color,
      
      child: SafeArea(
        child: Column(
          children: [
            
            Container(
              height: 80.0,
              width: double.infinity,
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20.0))
              ),
              alignment: Alignment.topCenter,
  
              child: DefaultTextStyle(
                style: TextStyle(                
                        fontSize: 35.0,
                        fontWeight: FontWeight.w800
                ),
                textAlign: TextAlign.center,

                child: AnimatedTextKit(
                  animatedTexts: [
                    ScaleAnimatedText(
                      animatedTitles[0],
                    ),
                    ScaleAnimatedText(
                      animatedTitles[1],
                    ),
                    ScaleAnimatedText(
                      animatedTitles[2],
                    ),
                  ],
                  
                  totalRepeatCount: 10,
                ),
              )
            ),

              SizedBox(height: 20.0),

            Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.all(6.0),
              margin: EdgeInsets.only(
                bottom: 60.0,
                left: 15.0,
                right: 20.0
              ),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2.0),
                borderRadius: BorderRadius.all(Radius.circular(20.0))
              ),

              child: Teexts().label(description, 20.0, Colors.white)
            )
          ]
        ),
      ),
    );
  }

}