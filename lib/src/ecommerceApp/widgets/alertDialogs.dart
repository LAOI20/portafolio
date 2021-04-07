import 'dart:ui';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/instance_manager.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:portafolio/src/ecommerceApp/controllers/ac-myAccountC.dart';

import 'package:portafolio/src/widgets/imagee.dart';
import 'package:portafolio/src/widgets/textfield.dart';

import 'package:flutter/material.dart';

class EcommerceAppAlertDialogs {

  //USE IN PAGE AC-MY-ACCOUNT
  changeCP(BuildContext context){
    final controller = Get.find<EcommerceAppMyAccountController>();
    
    TextEditingController postalCodeController = TextEditingController();

    return showDialog(
      context: context,
      builder: (context){
        return AlertDialog(
          contentPadding: EdgeInsets.all(0.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))
          ),

          content: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(15.0),

                  child: Teexts().textfield(
                    'C.P', 
                    20.0, 
                    postalCodeController,
                    type: TextInputType.number
                  )
                ),
              ]
            ),
          ),

          actions: [
            TextButton(
              child: Teexts().label('Listo', 20.0, Colors.blue),
              
              onPressed: () async{
                String value = postalCodeController.text.trim();

                if(value.length == 5){
                  controller.changePostalCode(context, value);
                }
              }
            )
          ],
        );
      }
    );
  }

  //USE IN PAGE AC-MY-ACCOUNT
  contactUs(BuildContext context){
    return showDialog(
      context: context,
      builder: (context){
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))
          ),

          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.all(15.0),

              child: Column(
                children: [
                  Teexts().label('Contactame', 30.0, Colors.black),

                    SizedBox(height: 10.0),

                  GestureDetector(
                    onTap: () async{
                      String url = 'whatsapp://send?phone=+523741078455&text=Hola';

                      await canLaunch(url) ?
                        launch(url) : print('ERROR');
                    },

                    child: Row(
                      children: [
                        Icon(FontAwesomeIcons.whatsapp, size: 30.0),

                          SizedBox(width: 5.0),

                        Text(
                          '3313155892',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 22.0,
                            decoration: TextDecoration.underline
                          ),
                        )
                      ],
                    ),
                  ),

                    SizedBox(height: 20.0),

                  Row(
                    children: [
                      Icon(Icons.email, size: 25.0),

                        SizedBox(width: 5.0),

                      Expanded(child: Teexts().label('aosoftware18@gmail.com', 18.0, Colors.black)),
                    ],
                  ),

                    SizedBox(height: 10.0),
                ]
              ),
            ),
          )
        );
      }
    );
  }

  //USE ALMOST ON ALL PAGES
  showImages(BuildContext context, List images){
    return showDialog(
      barrierColor: Colors.transparent,
      context: context,
      builder: (context){
        Size size = MediaQuery.of(context).size;

        return Container(
          height: size.height,
          width: size.width,

          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),

            child: Padding(
              padding: EdgeInsets.symmetric(vertical: size.height * 0.2),

              child: EcommerceAppShowImages(images: images)
            ),
          ),
        );
      }
    );
  }


}

//IT IS NECESSARY TO BE ABLE TO ZOOM THE IMAGE
class EcommerceAppShowImages extends StatefulWidget {

  final List images;

    EcommerceAppShowImages({Key key, this.images}) : super(key: key);

  @override
  _EcommerceAppShowImagesState createState() => _EcommerceAppShowImagesState();
}

class _EcommerceAppShowImagesState extends State<EcommerceAppShowImages> {

  TransformationController _transformationController = TransformationController();
  TapDownDetails _doubleTapDetails;

  bool enableScrolllPageView = true;
  

  void onDoubleTapDown(TapDownDetails details){
    _doubleTapDetails = details;
  }

  void onDoubleTapp(){
    if(_transformationController.value != Matrix4.identity()){

       _transformationController.value = Matrix4.identity();

    } else {
      
      final position = _doubleTapDetails.localPosition;

      
        _transformationController.value = Matrix4.identity()
        ..translate(-position.dx * 2, -position.dy * 2)
        ..scale(3.0);
      
    }
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onDoubleTapDown: (tapDetails){
        onDoubleTapDown(tapDetails);
        setState(() => enableScrolllPageView = !enableScrolllPageView);
      },
      onDoubleTap: (){
        onDoubleTapp();
      },

      child: Container(
        height: size.height * 0.5,
        width: size.width,

        child: InteractiveViewer(
          transformationController: _transformationController,

          child: PageView.builder(
            physics: enableScrolllPageView == true ? AlwaysScrollableScrollPhysics() : NeverScrollableScrollPhysics(),
            itemCount: widget.images.length,
            itemBuilder: (context, index){
              //CAN DO ZOOM
              return Imagee().squareImage(widget.images[index]);
            }
          ),
        ),
      ),
    );
  }
}