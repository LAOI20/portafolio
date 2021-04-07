import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/state_manager.dart';
import 'package:portafolio/src/services/myInfo.dart';

import 'package:portafolio/src/ecommerceApp/models/aca-officialStoresM.dart';

import 'package:portafolio/src/ecommerceApp/controllers/aca-officialStoresC.dart';

import 'package:portafolio/src/ecommerceApp/widgets/appBarContainer.dart';
import 'package:portafolio/src/ecommerceApp/widgets/loadList.dart';
import 'package:portafolio/src/widgets/backgroundImage.dart';
import 'package:portafolio/src/widgets/imagee.dart';
import 'package:portafolio/src/widgets/loadings.dart';
import 'package:portafolio/src/widgets/textfield.dart';

import 'package:flutter/material.dart';

class EcommerceAppOfficialStores extends StatelessWidget {
  const EcommerceAppOfficialStores({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    
    return GetBuilder<EcommerceAppOfficialStoresController>(
      init: EcommerceAppOfficialStoresController(),
      builder: (_) {
        return Scaffold(
          body: _.isLoadedData == false ?
            Loadings().loadWidgetFullScreen(context)
            :
            backgroundImage(
              child: Stack(
                children: [

                  //LIST STORES
                  _BodyPage(
                    officialStores: _.storess,
                  ),

                  //APP BAR
                  EcommerceAppContainerAppBar().appBar(
                    title: 'Tiendas oficiales',
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
    );
  }
}


class _BodyPage extends StatelessWidget {

  final List<StoreInfo> officialStores;
  
  const _BodyPage({Key key, this.officialStores}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return officialStores.length == 0 ?
      LoadingOfficialStores()
      :
      Column(
        children: [
          
          Spacer(),

          //SHOW DATA OF STORE
          Container(
            width: size.width,
            margin: EdgeInsets.symmetric(horizontal: 10.0),
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: MyInfo.isDarkMode != true ?
                Colors.pink : Colors.black54,
                
              borderRadius: BorderRadius.all(Radius.circular(40.0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  offset: Offset(0, 5.0),
                  blurRadius: 40.0,
                )
              ]
            ),

            child: GetBuilder<EcommerceAppOfficialStoresController>(
              id: 'infoStoreContainer',
              builder: (__) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Teexts().label(
                      'Nombre : ${officialStores[__.indexx].salesMan}', 
                      20.0, 
                      Colors.black
                    ),
                      
                      SizedBox(height: 8.0),

                    Teexts().label(
                      'Categoria : ${officialStores[__.indexx].category}', 
                      20.0, 
                      Colors.black
                    ),

                      SizedBox(height: 8.0),

                    Teexts().label(
                      'Productos vendidos : ${officialStores[__.indexx].soldProducts}', 
                      20.0, 
                      Colors.black
                    ),
                  ],
                );
              }
            )
          ),

            SizedBox(height: 70.0),

          //SHOW LIST STORE
          Container(
            height: size.height * 0.4,

            child: GetBuilder<EcommerceAppOfficialStoresController>(              
              builder: (__) {
                return CarouselSlider.builder(              
                  options: CarouselOptions(
                    scrollDirection: Axis.vertical,
                    enlargeCenterPage: true,

                    onPageChanged: (indx, ____){
                      __.onChangeCarousel(indx);
                    }
                  ),
                  itemCount: officialStores.length,
                  itemBuilder: (context, index, _){
                    return _StoreLogo(
                      logoUrl: officialStores[index].logoUrl,
                    );
                  }
                );
              }
            ),
          ),
        ],
      );
  }
}


class _StoreLogo extends StatelessWidget {

  final String logoUrl;

  const _StoreLogo({Key key, this.logoUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        border: Border.all(width: 3.0, color: Colors.black),
        borderRadius: BorderRadius.all(Radius.circular(20.0))
      ),

      child: ClipRRect(
        borderRadius: 
          BorderRadius.all(Radius.circular(20.0)),

        child: Imagee().squareImage(logoUrl)
      ),
    );
  }
}