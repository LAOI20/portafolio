import 'package:get/state_manager.dart';
import 'package:intl/intl.dart';
import 'package:portafolio/src/services/myInfo.dart';

import 'package:portafolio/src/navigation.dart';

import 'package:portafolio/src/ecommerceApp/controllers/aa-shoppingCartC.dart';

import 'package:portafolio/src/ecommerceApp/pages/aaa-payAllCart.dart';

import 'package:portafolio/src/ecommerceApp/widgets/productRow.dart';
import 'package:portafolio/src/widgets/textfield.dart';

import 'package:flutter/material.dart';

class EcommerceAppShoppingCart extends StatelessWidget {
  
  const EcommerceAppShoppingCart({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final moneda = NumberFormat.simpleCurrency();

    return GetBuilder<EcommerceAppShoppingCartController>(
      init: EcommerceAppShoppingCartController(),
      builder: (_) {
        return Scaffold(
          body: Stack(
            children: [
              
              //PRODUCTS ADD THE CART
              ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: _.homeController.myCartProducts.length,
                itemBuilder: (context, index){
                  return Padding(
                    padding: EdgeInsets.only(
                      top: index == 0 ? 80.0 : 0.0,
                      bottom: index == 9 ? 50.0 : 0.0
                    ),

                    child: GestureDetector(
                      onTap: () => _.onTapProduct(
                        _.homeController.myCartProducts[index]
                      ),
                      
                      child: EcommerceAppProductRow().product(
                        _.homeController.myCartProducts[index]
                      )
                    ),
                  );
                }
              ),

              //APP BAR
              Container( 
                height: 70.0,
                width: size.width,          
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: MyInfo.isDarkMode != true ?
                    Colors.pink : Colors.black54,
                    
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(40.0))
                ),

                child: SafeArea(
                  child: Teexts().label('Carrito', 27.0, Colors.black)
                )
              )
            ]
          ),

          bottomNavigationBar: _.totalPriceProducts == 0 ?
            SizedBox(height: 0.0,)
            :
            GestureDetector(
              onTap: (){ Nav().to(EcommerceAppPayAllCart()); },

              child: Container(
                height: 50.0,
                color: MyInfo.isDarkMode != true ?
                  Colors.pink : Colors.black54,
                  
                alignment: Alignment.center,

                child: Teexts().label('COMPRAR', 30.0, Colors.black),
              ),
            ),

          floatingActionButton: FloatingActionButton.extended(
            backgroundColor: Colors.black,
            label: Teexts().label(
              moneda.format(_.totalPriceProducts), 
              20.0, 
              Colors.white
            ),
            onPressed: (){}, 
          ),
        );
      }
    );
  }
}