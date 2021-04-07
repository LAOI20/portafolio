import 'package:get/state_manager.dart';

import 'package:portafolio/src/ecommerceApp/models/aca-officialStoresM.dart';

import 'package:portafolio/src/ecommerceApp/database/aca-officialStoresD.dart';

class EcommerceAppOfficialStoresController extends GetxController {

  bool isLoadedData = false;


  List<StoreInfo> storess = [];
  int indexx = 0;

  @override
  void onInit() {
    super.onInit();

    EcommerceAppOfficialStoresDatabase().getStoresInfo()
      .then((valueList){
        
        storess = valueList;
        isLoadedData = true;
        
        update();
      });
  }



  void onChangeCarousel(int indx){
    indexx = indx;
    update(['infoStoreContainer']);
  }
  
}