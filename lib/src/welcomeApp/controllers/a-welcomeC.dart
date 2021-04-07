import 'package:flutter/animation.dart';
import 'package:get/state_manager.dart';

class WelcomeAppWelcomeController extends GetxController with SingleGetTickerProviderMixin{

  bool uploadedImage = false;


  AnimationController pageAnimation;

  @override
  void onInit() {    
    super.onInit();

    pageAnimation = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 3000)
    );
    pageAnimation.forward();
  }
  
  @override
  void onReady() {
    super.onReady();
    print('on readyyyyy');
    /*  A WAY TO KNOW WHEN AN IMAGE IS LOADED FROM INTERNET

    Image.network(
                            'https://img.icons8.com/color/452/firebase.png',

                            loadingBuilder: (context, child, loadindProgress){
                              
                              if(loadindProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadindProgress.expectedTotalBytes != null ?
                                          loadindProgress.cumulativeBytesLoaded / loadindProgress.expectedTotalBytes
                                          :
                                          null
                                ),
                              );
                            }
                          ),
    
    ---------------------------------------------------
       
    this.firebaseLogo = NetworkImage('https://img.icons8.com/color/452/firebase.png');

    this.firebaseLogo.resolve(ImageConfiguration())
        .addListener(ImageStreamListener((info, call) {
          this.uploadedImage = true;
          update();
          print('imagen cargada');
        })); */
    
  }

  @override
  void onClose() {
    
    pageAnimation.dispose();
    
    super.onClose();
  }

}