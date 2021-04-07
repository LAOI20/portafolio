import 'package:get/state_manager.dart';

import 'package:portafolio/src/ecommerceApp/models/a-homeM.dart';

import 'package:portafolio/src/ecommerceApp/database/acaa-storePageD.dart';

class EcommerceAppStorePageController extends GetxController {

  static String storeName;

  List<ProductInfo> productsList = [];

  int soldProducts;


  @override
  void onInit() {    
    super.onInit();

    EcommerceAppStorePageDatabase().getStoreProducts(storeName)
      .then((value){
        productsList = value;
        
      }).then((v){
        
        EcommerceAppStorePageDatabase().getSoldProducts(storeName)
          .then((result){
            soldProducts = result;

            update();
          });

      });
  }



}