import 'package:get/state_manager.dart';
import 'package:portafolio/src/services/myInfo.dart';

import 'package:portafolio/src/navigation.dart';

import 'package:portafolio/src/ecommerceApp/controllers/ac-myAccountC.dart';

import 'package:portafolio/src/ecommerceApp/pages/aca-officialStores.dart';

import 'package:portafolio/src/ecommerceApp/widgets/bottomSheets.dart';
import 'package:portafolio/src/ecommerceApp/widgets/alertDialogs.dart';
import 'package:portafolio/src/ecommerceApp/widgets/appBarContainer.dart';
import 'package:portafolio/src/widgets/buttons.dart';
import 'package:portafolio/src/widgets/loadings.dart';
import 'package:portafolio/src/widgets/textfield.dart';

import 'package:flutter/material.dart';

class EcommerceAppMyAccount extends StatelessWidget {
  const EcommerceAppMyAccount({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),

        child: Stack(
          children: [

            //BODY PAGE
            _BodyPage(),

            //APP BAR
            EcommerceAppContainerAppBar().appBar(
              title: 'Mi cuenta',
              color: MyInfo.isDarkMode != true ?
                Colors.pink : Colors.black54,
                
              height: 70.0,
              width: size.width
            )            
          ]
        ),
      ),
    );
  }
}


class _BodyPage extends StatelessWidget {
  const _BodyPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EcommerceAppMyAccountController>(
      init: EcommerceAppMyAccountController(),
      builder: (_) {
        return _.isLoaded != true ?
          Loadings().loadWidgetFullScreen(context)
          :
          Padding(
            padding: const EdgeInsets.only(top: 120.0),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                textContainer(
                  Icons.account_circle,
                  MyInfo.myName,
                  null
                ),

                Row(
                  children: [
                    textContainer(
                      Icons.contact_mail_rounded,
                      'C.P : ${MyInfo.myPostalCode}',
                      (){}
                    ),

                    Buttons().buttonIcon(Icons.edit, 30.0, () { 
                      EcommerceAppAlertDialogs().changeCP(context);
                    })
                  ],
                ),

                Divider(thickness: 4.0),

                textContainer(
                  Icons.history_toggle_off_outlined,
                  'Historial',
                  (){ 
                    print(_.historialProducts.length);
                    EcommerceAppBottomSheets().showMyHistorial(
                      context, _.historialProducts
                    );
                  }
                ),

                Divider(thickness: 4.0),

                textContainer(
                  Icons.store,
                  'Tiendas oficiales',
                  (){ Nav().to(EcommerceAppOfficialStores()); }
                ),

                Divider(thickness: 4.0),

                //CHANGE THEME
                Row(
                  children: [
                    Switch(
                      value: MyInfo.isDarkMode, 
                      onChanged: (val) => _.onChangeTheme(val)
                    ),

                    Icon(
                      MyInfo.isDarkMode == false ? 
                        Icons.wb_sunny
                        :
                        Icons.brightness_3,
                        
                      size: 30.0
                    )
                  ]
                ),

                  SizedBox(height: 10.0),

                //CONTACT US
                Align(
                  alignment: Alignment.bottomRight,

                  child: Buttons().buttonIcon(Icons.info, 40.0, () { 
                    EcommerceAppAlertDialogs().contactUs(context);
                  }),
                ),

                  SizedBox(height: 30.0)
              ]
            ),
          );
      }
    );    
  }

  Widget textContainer(IconData icon,String text,VoidCallback onTap){
    return GestureDetector(
      onTap: onTap,

      child: Container(
        height: 50.0,
        color: Colors.transparent,

        child: Row(
          children: [
              SizedBox(width: 5.0),

            Icon(icon, size: 30.0),

              SizedBox(width: 5.0),

            Teexts().label(text, 20.0, Colors.black),
          ],
        ),
      ),
    );
  }
}