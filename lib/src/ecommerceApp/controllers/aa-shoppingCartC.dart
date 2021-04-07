import 'package:get/state_manager.dart';
import 'package:get/instance_manager.dart';

import 'package:portafolio/src/navigation.dart';

import 'package:portafolio/src/ecommerceApp/controllers/a-homeC.dart';

import 'package:portafolio/src/ecommerceApp/models/a-homeM.dart';

import 'package:portafolio/src/ecommerceApp/pages/ab-productPage.dart';

class EcommerceAppShoppingCartController extends GetxController {

  //FOR GET CART PRODUCTS
  final homeController = Get.find<EcommerceAppHomeController>();


  int totalPriceProducts = 0;


  @override
  void onInit() {    
    super.onInit();

    homeController.myCartProducts.forEach((product) {
      if(product.isOffer == true){
        totalPriceProducts = totalPriceProducts + product.offPrice;
      } else {
        totalPriceProducts = totalPriceProducts + product.price;
      }
    });

    update();
  }
  


  void onTapProduct(ProductInfo product){

    homeController.selectedProduct = product;
    
    Nav().to(EcommerceAppProductPage());
  }


}