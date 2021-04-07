import 'package:get/state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:portafolio/src/ecommerceApp/models/ac-myAccountM.dart';

import 'package:portafolio/src/navigation.dart';

import 'package:portafolio/src/ecommerceApp/models/a-homeM.dart';

import 'package:portafolio/src/ecommerceApp/controllers/a-homeC.dart';
import 'package:portafolio/src/ecommerceApp/controllers/ab-productPageC.dart';

import 'package:portafolio/src/ecommerceApp/pages/ad-purchaseDetails.dart';

import 'package:portafolio/src/ecommerceApp/widgets/productGridView.dart';
import 'package:portafolio/src/ecommerceApp/widgets/productRow.dart';
import 'package:portafolio/src/ecommerceApp/widgets/reviewContainer.dart';
import 'package:portafolio/src/widgets/bottomSheetModel.dart';
import 'package:portafolio/src/widgets/textfield.dart';

import 'package:flutter/material.dart';

class EcommerceAppBottomSheets {


  //USE IN PAGE A-HOME
  showProductsInOffer(BuildContext context,List<ProductInfo> products){
    final homeController = Get.find<EcommerceAppHomeController>();

    return BottomSheetModel().bottomSheet(
      context: context,
      builder: (context, scrollController){
        return BottomSheetModel().columnAndTitle(
          title: 'Ofertas',

          child:  GridView.builder(
            controller: scrollController,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              childAspectRatio: 1/1.3
            ),
            itemCount: products.length,

            itemBuilder: (context, index){
              return GestureDetector(
                onTap: (){
                  homeController.navigationProductPage(
                    products[index]
                  );
                },

                child: EcommerceAppProductGridView().product(
                  context, products[index],               
                )
              );
            }
          )
        );
      }
    );
  }

  //USE IN PAGE A-HOME
  showFavorites(BuildContext context,List<ProductInfo> productsList){
    final homeController = Get.find<EcommerceAppHomeController>();

    return BottomSheetModel().bottomSheet(
      context: context,
      builder: (context, scrollController){
        return BottomSheetModel().columnAndTitle(
          title: 'Favoritos',

          child: ListView.builder(
            controller: scrollController,
            itemCount: productsList.length,
            itemBuilder: (context, index){
              return GestureDetector(
                onTap: () => homeController.navigationProductPage(
                  productsList[index]
                ),

                child: EcommerceAppProductRow().product(productsList[index])
              );
            }
          ),
        );
      }
    );
  }

  //USE IN PAGE A-HOME
  showMyShopping(BuildContext context,List<ProductInfo> productsList){
    return BottomSheetModel().bottomSheet(
      context: context,      
      builder: (context, scrollController){
        return BottomSheetModel().columnAndTitle(
          title: 'Mis compras',

          child: ListView.builder(
            controller: scrollController,
            itemCount: productsList.length,
            itemBuilder: (context, index){
              return GestureDetector(
                onTap: (){ 
                  Nav().to(EcommerceAppPurchaseDetails(
                    productID: productsList[index].productID,
                  )); 
                },
                
                child: EcommerceAppProductRow().product(productsList[index])
              );
            }
          ),
        );
      }
    );
  }

  //USE IN PAGE AC-MY-ACCOUNT
  showMyHistorial(BuildContext context,List<ProductHistorial> productsList){
    return BottomSheetModel().bottomSheet(
      context: context,
      builder: (context, scrollController){
        return BottomSheetModel().columnAndTitle(
          title: 'Historial',

          child: ListView.builder(
            controller: scrollController,
            itemCount: productsList.length,
            itemBuilder: (context, index){
              return EcommerceAppProductRow().productHistorial(
                productsList[index]
              );
            }
          ),
        );
      }
    );
  }
  


  //USE IN PAGE AB-PRODUCT-PAGE
  showReviewsProduct(BuildContext context){
    return BottomSheetModel().bottomSheet(
      context: context,
      builder: (context, scrollController){
        return BottomSheetModel().columnAndTitle(
          title: 'opiniones',

          child: GetBuilder<EcommerceAppProductPageController>(
            id: 'reviewsBottomSheetContainer',
            builder: (_) {
              return DefaultTabController(
                length: 2,
                
                child: Column(
                  children: [
                    TabBar(
                      onTap: (index) => _.onTapTabBar(index),
                      indicatorColor: Colors.grey[300],
                      labelColor: Colors.black,
                      tabs: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),

                          child: Teexts().label(
                            'Positivas', 
                            _.positiveOrNegative == 0 ? 21.0 : 16.0, 
                            _.positiveOrNegative == 0 ? Colors.black : Colors.grey 
                          )
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          
                          child: Teexts().label(
                            'Negativas', 
                            _.positiveOrNegative == 1 ? 21.0 : 16.0, 
                            _.positiveOrNegative == 1 ? Colors.black : Colors.grey 
                          )
                        )
                      ],
                    ),

                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: _.reviewsList.length,
                        itemBuilder: (context, index){
                          if(_.positiveOrNegative == 0 && 
                              _.reviewsList[index].ranking >= 3
                          ){//SHOW POSITIVES REVIEWS
                            return EcommerceAppReviewContainer().container(
                              _.reviewsList[index]
                            );

                          } else if(_.positiveOrNegative == 1 &&
                                    _.reviewsList[index].ranking <= 2
                          ){//SHOW NEGATIVES REVIEWS
                            return EcommerceAppReviewContainer().container(
                              _.reviewsList[index]
                            );
                          } else {
                            return SizedBox(height: 0.0);
                          }
                        }
                      )
                    )
                  ]
                ),
              );
            }
          ),
        );
      }
    );
  }

}