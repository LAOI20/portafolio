import 'package:get/state_manager.dart';
import 'package:liquid_swipe/liquid_swipe.dart';

import 'package:portafolio/src/navigation.dart';

import 'package:portafolio/src/welcomeApp/controllers/0-onboardingC.dart';

import 'package:portafolio/src/welcomeApp/pages/a-welcome.dart';

import 'package:flutter/material.dart';

class WelcomeAppOnboardingPage extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {    
    final _controller = WelcomeAppOnboardingController();

    return Scaffold(
      body: Stack(
        children: [

          LiquidSwipe(
            enableLoop: false,
            slideIconWidget: Icon(
              Icons.arrow_forward_ios, 
              color: Colors.cyan,
              size: 40.0,
            ),
            ignoreUserGestureWhileAnimating: true,
            pages: _controller.pages,
            onPageChangeCallback: _controller.selectPageIndex
          ),

          Positioned(
            bottom: 15.0,
            left: 10.0,

            child: Row(
              children: List.generate(
                _controller.pages.length, (index) => Obx((){
                  return Container(
                    margin: EdgeInsets.all(6.0),
                    height: 12.0,
                    width: 12.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _controller.selectPageIndex.value == index ?
                              Colors.black
                              :
                              Colors.blueGrey
                    ),
                  );
                })
              )
            ),
          ),

        
            Positioned(
              bottom: 15.0,
              right: 15.0,

              child: Obx((){
                return _controller.selectPageIndex.value != 2 ?
                        SizedBox(height: 0.0)
                        :
                        FloatingActionButton(
                          backgroundColor: Colors.transparent,

                          onPressed: (){ 
                            Nav().toUntil(WelcomeAppWelcome()); 
                          },

                          child: Icon(
                            Icons.check_circle,
                            size: 60.0,
                            color: Colors.blue[900]
                          ),
                        );
              })
            )
        ],
      ),
    );
  }
}