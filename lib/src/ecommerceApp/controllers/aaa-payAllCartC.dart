import 'package:portafolio/src/services/myInfo.dart';
import 'package:get/state_manager.dart';
import 'package:get/instance_manager.dart';

import 'package:portafolio/src/navigation.dart';

import 'package:portafolio/src/ecommerceApp/controllers/a-homeC.dart';
import 'package:portafolio/src/ecommerceApp/controllers/aa-shoppingCartC.dart';

import 'package:portafolio/src/services/APImodel.dart';

import 'package:portafolio/src/ecommerceApp/database/aaa-payAllCartD.dart';

import 'package:portafolio/src/widgets/alertMessage.dart';

class EcommerceAppPayAllCartController extends GetxController {

  final shoppingCartController = Get.find<EcommerceAppShoppingCartController>();
  final homeController = Get.find<EcommerceAppHomeController>();
  

  bool loadedData = false;

  bool isLoadedPayment = false;


  double shipmentPrice;

  String estimatedDelivery;

  String addressDestination;


  @override
  void onInit() {
    super.onInit();

    getDataShipment();
  }



  void getDataShipment(){
    APImodel().getDataShipment(postalCode: MyInfo.myPostalCode, shipmentName: 'fedex')
      .then((dataList){
        //DATALIST[0] = ESTIMATED DELIVERY
        //DATALIST[1] = TOTAL AMOUNT
        //DATALIST[2] = DESTINATION ADDRESS
        if(dataList != null){
          shipmentPrice = dataList[1];
          estimatedDelivery = dataList[0];
          addressDestination = dataList[2];

          loadedData = true;

          update();

        } else {
          shipmentPrice = 175;
          estimatedDelivery = 'mañana';
          
          loadedData = true;

          update();
        }

      });
  }


  void paymentIntentLoaded(bool isFinished){

    isLoadedPayment = isFinished == false ? true : false;

    if(isFinished == true){
      homeController.myCartProducts.clear();
      EcommerceAppPayAllCartDatabase().cleanMyShoppingCart();

      Nav().back();
      Nav().back();
      AlertMessage().alertaMensaje('Compra exitosa');
    }

    update();
  }


}