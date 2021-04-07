import 'package:get/state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:portafolio/src/services/APImodel.dart';
import 'package:portafolio/src/services/myInfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:portafolio/src/navigation.dart';

import 'package:portafolio/src/ecommerceApp/controllers/a-homeC.dart';

import 'package:portafolio/src/ecommerceApp/models/a-homeM.dart';
import 'package:portafolio/src/ecommerceApp/models/ab-productPageM.dart';

import 'package:portafolio/src/ecommerceApp/database/ab-productPageD.dart';

import 'package:portafolio/src/ecommerceApp/pages/aba-payProduct.dart';

import 'package:portafolio/src/widgets/alertMessage.dart';
import 'package:portafolio/src/widgets/textfield.dart';
import 'package:flutter/material.dart';


class EcommerceAppProductPageController extends GetxController {
  
  //FOR GET PRODUCT INFO
  final homeController = Get.find<EcommerceAppHomeController>();

  bool avaibleSizes;

  bool isFavorite;
  bool isCartProduct;

  int selectSize;

  String sizeNameSelect;

  List<ReviewInfo> reviewsList = [];

  //IS NECCESARY USE VAR CAUSE THE VALUE CAN BE INT OR DOUBLE
  var averageReviews;

  bool onPresButtonBuyNow = false;

  List<bool> checkBoxsList = [false, false];
  String shipmentName;

  
  double shipmentPrice;
  String estimatedDelivery;
  String destinationAddress;



  @override
  void onInit() {    
    super.onInit();
    
    getReviewsProduct(homeController.selectedProduct.refDatabaseProduct);

    if(homeController.selectedProduct.sizes != null){
      avaibleSizes = true;
    }


    //KNOW IF PRODUCT IS FAVORITE PRODUCT
    homeController.myFavoritesProducts.forEach((element) {
      if(element.productID == homeController.selectedProduct.productID){
        isFavorite = true;
        update(['iconsContainer']);
        print('si hay favorito');
      }
    });

    //KNOW IF PRODUCT IS CART PRODUCT   
    homeController.myCartProducts.forEach((element) {
      if(element.productID == homeController.selectedProduct.productID){
        isCartProduct = true;
        update(['iconsContainer']);
        print('si hay favorito');
      }
    });

  }


  void addToFavorite(BuildContext context,ProductInfo product){    

    EcommerceAppProductPageDatabase().addProductToFavorite(product);
    
    isFavorite = true;
    update(['iconsContainer']);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: MyInfo.isDarkMode != true ?
        Colors.white12 : Colors.black87,

      content: Teexts().label('Agregado a favoritos', 20.0, Colors.white)
    ));

    homeController.myFavoritesProducts.add(product);

  }


  void addToCart(BuildContext context,ProductInfo product){

    EcommerceAppProductPageDatabase().addProductToCart(product);
    isCartProduct = true;
    update(['iconsContainer']);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: MyInfo.isDarkMode != true ?
        Colors.white12 : Colors.black87,

      content: Teexts().label('Agregado al carrito', 20.0, Colors.white)
    ));

    homeController.myCartProducts.add(product);
  }



  //IS CALL FROM PREVIOUS PAGE
  void getReviewsProduct(DocumentReference docREF){
    
    EcommerceAppProductPageDatabase().getProductReviews(docREF)
      .then((resultList){
        
        reviewsList = resultList;
        
        //GET AVERAGE REVIEWS
        List<int> rankingReviews = []; 
        
        resultList.forEach((element) {
          rankingReviews.add(element.ranking);
        });

        averageReviews = rankingReviews.reduce((a, b) => a + b) / resultList.length;
        
        update(['reviewsContainer', 'reviewsBottomSheetContainer']);
      });
  }



  void selectCheckBox(int indx){

    //ON TAP FEDEX
    if(indx == 0){
      checkBoxsList[0] = !checkBoxsList[0];
      checkBoxsList[1] = false;

      shipmentName = 'fedex';

      update(['chooseShipmentContainer']);

      //ON TAP ESTAFETA
    } else {
      checkBoxsList[1] = !checkBoxsList[1];
      checkBoxsList[0] = false;

      shipmentName = 'estafeta';

      update(['chooseShipmentContainer']);
    }
  }


  void onTapSize(int indxSize,String sizeName){
    selectSize = indxSize;
    sizeNameSelect = sizeName;

    update(['sizesGuideContainer']);
  }


  void onTapBuyNowButton(){    

    if(shipmentName != null){

      if(shipmentPrice == null){
        
        if(avaibleSizes == true){

          checkIfSizeNull();

        } else {
          
          onPresButtonBuyNow = true;
          update(['buttonBuyNowContainer']);

          APImodel().getDataShipment(postalCode: MyInfo.myPostalCode, shipmentName: shipmentName)
            .then((dataList){
              //DATALIST[0] = ESTIMATED DELIVERY
              //DATALIST[1] = TOTAL AMOUNT
              //DATALIST[2] = DESTINATION ADDRESS
              if(dataList != null){
                shipmentPrice = dataList[1];
                estimatedDelivery = dataList[0];
                destinationAddress = dataList[2];
                
                Nav().to(EcommerceAppPayProduct());

                onPresButtonBuyNow = false;
                update(['buttonBuyNowContainer']);

              } else {
                shipmentPrice = 175;
                estimatedDelivery = 'mañana';
                
                Nav().to(EcommerceAppPayProduct());

                onPresButtonBuyNow = false;
                update(['buttonBuyNowContainer']);
              }

            });
        }

      } else {

        Nav().to(EcommerceAppPayProduct());

      }

    } else {
      AlertMessage().alertaMensaje('Debes elegir una paqueteria');
    }

  }
  
  void checkIfSizeNull(){
    if(sizeNameSelect != null){
      
      onPresButtonBuyNow = true;
      
      update(['buttonBuyNowContainer']);

      APImodel().getDataShipment(postalCode: MyInfo.myPostalCode, shipmentName: shipmentName)
        .then((dataList){
          //DATALIST[0] = ESTIMATED DELIVERY
          //DATALIST[1] = TOTAL AMOUNT
          //DATALIST[2] = DESTINATION ADDRESS
          print("responseeeeeee $dataList");
          if(dataList.length != 3){
            
            shipmentPrice = dataList[1];
            estimatedDelivery = dataList[0];
            destinationAddress = dataList[2];
            
            Nav().to(EcommerceAppPayProduct());

            onPresButtonBuyNow = false;
            update(['buttonBuyNowContainer']);

          } else {
            shipmentPrice = 175;
            estimatedDelivery = 'mañana';
            destinationAddress = 'desconocido';
            
            Nav().to(EcommerceAppPayProduct());

            onPresButtonBuyNow = false;
            update(['buttonBuyNowContainer']);
          }

        }); 

    } else {
      AlertMessage().alertaMensaje('Debes elegir una talla');
    }
  }


//BOTTOMSHEETS
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  // 0 == SHOW POSITIVES REVIEWS | 1 == SHOW NEGATIVES REVIEWS
  int positiveOrNegative = 0;

  void onTapTabBar(int indx){
    positiveOrNegative = indx;
    update(['reviewsBottomSheetContainer']);
  }

}