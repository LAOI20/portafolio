import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/state_manager.dart';
import 'package:get/instance_manager.dart';

import 'package:portafolio/src/welcomeApp/controllers/ab-loginFirebaseC.dart';

import 'package:portafolio/src/welcomeApp/widgets/bottomSheets.dart';
import 'package:portafolio/src/widgets/buttons.dart';
import 'package:portafolio/src/widgets/imagee.dart';
import 'package:portafolio/src/widgets/loadings.dart';
import 'package:portafolio/src/widgets/textfield.dart';

import 'package:flutter/material.dart';


class WelcomeAppLoginFirebase extends StatelessWidget {
  const WelcomeAppLoginFirebase({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GetBuilder<WelcomeAppLoginFirebaseController>(
      init: WelcomeAppLoginFirebaseController(),
      builder: (_) {
        return Scaffold(
          body: Stack(
            children: [
              GestureDetector(
                onTap: (){ FocusScope.of(context).unfocus(); },

                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),

                  child: Stack(
                    children: [

                      //BLUE CONTAINER            
                      ClipPath(
                        clipper: BlueContainerClipper(),
                        child: Container(
                          height: size.height * 0.25,
                          width: size.width,
                          color: Colors.blue[800],
                        ),
                      ),

                      //FIREBASE IMAGE
                      Padding(
                        padding: EdgeInsets.only(top: size.height * 0.12),

                        child: Center(
                          child: Imagee().imageContainer(
                            size: 100.0,
                            imageUrl: 'https://img.icons8.com/color/452/firebase.png'                        
                          ),
                        ),
                      ),

                      //TEXTFIELDS LOGIN, BUTTON LOGIN, TEXT BUTTON REGISTER,
                      //SIGN IN WITH GOOGLE, FACEBOOK
                      _PageBodyLogin(),                  
                    ],
                  ),
                ),
              ),

              _.showLoadedScreen == true ?
                Loadings().loadWidgetFullScreen(context)
                :
                SizedBox(height: 0.0)
            ],
          ),
        );
      }
    );

  }

}


class _PageBodyLogin extends StatelessWidget {
  const _PageBodyLogin({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<WelcomeAppLoginFirebaseController>();
    Size size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          top: size.height * 0.3,
          left: 20.0,
          right: 20.0
        ),

        child: Column(
          children: [ 

            _SlideTransitionWidget(
              animation: controller.controllerAnimation,
              beginDX: 2,
              beginAnimation: 0,
              endAnimation: 0.2,
              child: Teexts().textfield(
                'Email', 
                20.0, 
                controller.emailController,
                type: TextInputType.emailAddress,
                action: TextInputAction.next
              ),
            ),

              SizedBox(height: 10.0),

            _SlideTransitionWidget(
              animation: controller.controllerAnimation,
              beginDX: 2,
              beginAnimation: 0.15,
              endAnimation: 0.4,

              child: Teexts().textfield(
                'Contraseña', 
                20.0, 
                controller.passwordController,
                obscure: true,
              ),
            ),

              SizedBox(height: 40.0),

            //LOGIN BUTTON
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),

              child: _SlideTransitionWidget(
                animation: controller.controllerAnimation,
                beginDX: -2,
                beginAnimation: 0.35,
                endAnimation: 0.6,

                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(40.0))
                    ),
                    primary: Colors.orange[400],
                    elevation: 20.0,
                  ),
                  
                  onPressed: (){  
                    controller.loginWithEmailPassword(context);
                  },

                  child: Container(
                    height: 70.0,
                    width: size.width,

                    child: Center(
                      child: Teexts().label('Iniciar Sesion', 25.0, Colors.black)
                    ),
                  ),
                ),
              ),
            ),

              SizedBox(height: size.height * 0.05),

            GestureDetector(
              onTap: (){ WelcomeAppBottomSheets().newUserFirebase(context); },

              child: _SlideTransitionWidget(
                animation: controller.controllerAnimation,
                beginDX: -2,
                beginAnimation: 0.55,
                endAnimation: 0.8,
                
                child: Teexts().label('Registrarse', 26.0, Colors.black)
              ),
            ),

              SizedBox(height: size.height * 0.05),

            _ScaleWidget(
              animation: controller.loginIconsAnimation,
              beginAnimation: 0,
              endAnimation: 0.25,

              child: Teexts().label('Continuar con', 20.0, Colors.black)
            ),

              SizedBox(height: 10.0),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),

              child: Row(
                children: [
                  _ScaleWidget(
                    animation: controller.loginIconsAnimation,
                    beginAnimation: 0.25,
                    endAnimation: 0.5,

                    child: Buttons().buttonIcon(FontAwesomeIcons.google, 35, () { 
                      controller.onTapGoogle(context);
                    },
                      color: Color.fromRGBO(219, 68, 55, 1)
                    ),
                  ),
                  
                  Spacer(),

                  _ScaleWidget(
                    animation: controller.loginIconsAnimation,
                    beginAnimation: 0.5,
                    endAnimation: 0.75,

                    child: Buttons().buttonIcon(FontAwesomeIcons.facebookF, 35, () { 
                      controller.onTapFacebook(context);
                    },
                      color: Color.fromRGBO(66, 103, 178, 1)
                    ),
                  ),
                  
                  Spacer(),

                  _ScaleWidget(
                    animation: controller.loginIconsAnimation,
                    beginAnimation: 0.75,
                    endAnimation: 1,

                    child: Buttons().buttonIcon(FontAwesomeIcons.phoneAlt, 35, () { 
                      WelcomeAppBottomSheets().authWithPhoneNumber(context);
                    }),
                  ),

                ]
              ),
            ),

              SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}

class BlueContainerClipper extends CustomClipper<Path> {

  @override
  Path getClip(Size size) {
    var path = Path();

    path.lineTo(0, size.height * 0.6);
    path.quadraticBezierTo(size.width * 0.5, size.height, size.width, size.height * 0.6);
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}


class _SlideTransitionWidget extends StatelessWidget {

  final Animation animation;
  final double beginDX;
  final double beginAnimation;
  final double endAnimation;
  final Widget child;

  const _SlideTransitionWidget({Key key, this.animation, this.beginDX, this.child, this.beginAnimation, this.endAnimation}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(beginDX, 0),
        end: Offset(0, 0)
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Interval(
          beginAnimation,
          endAnimation,
          curve: Curves.decelerate
        )
      )),

      child: child,
    );
  }
}

class _ScaleWidget extends StatelessWidget {

  final Animation animation;
  final double beginAnimation;
  final double endAnimation;
  final Widget child;

  const _ScaleWidget({Key key, this.animation, this.beginAnimation, this.endAnimation, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: CurvedAnimation(
        curve: Interval(
          beginAnimation,
          endAnimation,
          curve: Curves.elasticOut
        ),
        parent: animation
      ),

      child: child,
    );
  }
}
