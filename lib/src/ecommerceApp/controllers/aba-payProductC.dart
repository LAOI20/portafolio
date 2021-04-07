import 'package:get/state_manager.dart';
import 'package:get/instance_manager.dart';

import 'package:portafolio/src/navigation.dart';

import 'package:portafolio/src/ecommerceApp/controllers/a-homeC.dart';
import 'package:portafolio/src/ecommerceApp/controllers/ab-productPageC.dart';

import 'package:portafolio/src/widgets/alertMessage.dart';

class EcommerceAppPayProductController extends GetxController {

  //FOR GET PRODUCT INFO
  final homeController = Get.find<EcommerceAppHomeController>();

  //FOR GET PRODUCT SIZE INFO
  final productController = Get.find<EcommerceAppProductPageController>();


  bool isLoadedPayment = false;


  int amount = 1;

  int productPrice;

  String estimatedDelivery;

  int totalPrice;


  @override
  void onInit() {
    super.onInit();
      
    productPrice = homeController.selectedProduct.isOffer == true ?
      homeController.selectedProduct.offPrice
      :
      homeController.selectedProduct.price;

    totalPrice = (productPrice * amount) + productController.shipmentPrice.toInt();

    estimatedDelivery = productController.estimatedDelivery;
      
  }



  void changeAmount({bool increment}){
    
    if(increment == true && amount >= 1){
      
      double unitPrice = productPrice / amount;
      amount++;
      productPrice = unitPrice.toInt() * amount;
      totalPrice = productPrice + productController.shipmentPrice.toInt();

      update(['amountContainer', 'productPriceContainer','totalPriceContainer']);

    } else if(increment == false && amount > 1){

      double unitPrice = productPrice / amount;
      amount--;
      productPrice = productPrice - unitPrice.toInt();
      totalPrice = productPrice + productController.shipmentPrice.toInt();

      update(['amountContainer', 'productPriceContainer','totalPriceContainer']);
    }
  }


  void paymentIntent(bool isFinished){
    isLoadedPayment = isFinished == false ? true : false;

    if(isFinished == true){
      Nav().back();
      AlertMessage().alertaMensaje('Compra exitosa');
    }

    update();
  }

}