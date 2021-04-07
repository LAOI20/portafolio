import 'package:get/state_manager.dart';
import 'package:get/instance_manager.dart';

import 'package:portafolio/src/welcomeApp/controllers/ab-loginFirebaseC.dart';

import 'package:portafolio/src/widgets/bottomSheetModel.dart';
import 'package:portafolio/src/widgets/buttons.dart';
import 'package:portafolio/src/widgets/loadings.dart';
import 'package:portafolio/src/widgets/textfield.dart';

import 'dart:async';
import 'package:flutter/material.dart';

class WelcomeAppBottomSheets {
  
  //USE IN PAGE AB-LOGIN-FIREBASE
  newUserFirebase(BuildContext context){
    Size size = MediaQuery.of(context).size;

    bool isLoad = false;

    return BottomSheetModel().bottomSheet(
      context: context,
      builder: (context, scrollController){
        return BottomSheetModel().columnAndTitle(
          title: 'Registrarse',

          child: StatefulBuilder(
            builder: (context, setstate){
              return isLoad != false ?
                Loadings().loadWidgetInBottomSheet()
                :
                SingleChildScrollView(
                controller: scrollController,
                
                child: GetBuilder<WelcomeAppLoginFirebaseController>(
                  id: 'BSnewUser',
                  builder: (_){
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6.0
                      ),

                      child: Column(
                        children: [
                          Teexts().textfield(
                            'Nombre y apellido', 
                            20.0, 
                            _.nameRegisterController,
                            action: TextInputAction.next
                          ),
                            
                            SizedBox(height: 10.0),

                          Teexts().textfield(
                            'Email', 
                            20.0, 
                            _.emailRegisterController,
                            type: TextInputType.emailAddress,
                            action: TextInputAction.next
                          ),
                            
                            SizedBox(height: 10.0),

                          Teexts().textfield(
                            'Contraseña', 
                            20.0, 
                            _.passwordRegisterController,
                            obscure: true
                          ),

                            SizedBox(height: 40.0),
                          
                          Buttons().buttonIcon(Icons.check_circle, 60.0, () { 
                            setstate(() => isLoad = true);
                            
                            _.createUserEmailPassword(context);

                            Timer(Duration(seconds: 5), (){
                              setstate(() => isLoad = false);
                            });
                          }),

                            SizedBox(height: size.height * 0.5)
                        ],
                      ),
                    );
                  }
                )
              );
            }
          ),
        );
      }
    );
  }


  authWithPhoneNumber(BuildContext context){
    final controller = Get.find<WelcomeAppLoginFirebaseController>();
    TextEditingController numberController = TextEditingController();

    bool isLoaded = false;

    return BottomSheetModel().bottomSheet(
      context: context,
      builder: (context, scrollController){
        return BottomSheetModel().columnAndTitle(
          title: 'Numero celular',

          child: StatefulBuilder(
            builder: (context, setstate){
              return isLoaded != false ?
                Loadings().loadWidgetInBottomSheet()
                :
                SingleChildScrollView(
                controller: scrollController,
                
                child: Column(
                  children: [
                      const SizedBox(height: 4.0,),

                    //TEXT FIELD PHONE NUMBER
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(15.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0)
                            ),

                            child: Teexts().label('+52', 20.0, Colors.black)
                          ),

                            const SizedBox(width: 8.0,),

                          Expanded(
                            child: TextField(
                              controller: numberController,
                              maxLength: 10,
                              keyboardType: TextInputType.number, 
                              style: TextStyle(fontSize: 18.0),

                              decoration: InputDecoration(    
                                hintText: 'numero',
                                hintStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.0, 
                                )
                              ),
                            ),
                          ),
                        ],
                      )
                    ),

                      const SizedBox(height: 10.0,),

                    //ICONBUTTON ACCEPT
                    Buttons().acceptButton(60.0, () { 
                      setstate(() => isLoaded = true);

                      if(numberController.text.trim().length == 10){

                        controller.loginWithPhoneNumber(
                          "+52${numberController.text}"
                        );
                      } 
                    }),

                      const SizedBox(height: 30.0,),

                  ],
                ),
              );
            }
          )
        );
      }
    );
  }

}