import 'package:intl/intl.dart';
import 'package:portafolio/src/services/myInfo.dart';

import 'package:portafolio/src/ecommerceApp/models/a-homeM.dart';

import 'package:portafolio/src/widgets/imagee.dart';
import 'package:portafolio/src/widgets/textfield.dart';

import 'package:flutter/material.dart';

class EcommerceAppProductGridView {

  //USE IN PAGE A-HOME
  Widget product(BuildContext context,ProductInfo product){
    
    final moneda = NumberFormat.simpleCurrency(decimalDigits: 0);

    return Container(
      decoration: BoxDecoration(
        color: MyInfo.isDarkMode != true ?
          Colors.white : Colors.transparent,
          
        borderRadius: BorderRadius.circular(10.0)
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          //PRODUCT IMAGES
          Expanded(            
            child: Container(
              width: double.infinity,

              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),

                child: Imagee().squareImage(product.images[0])
              ),
            )
          ),

          Padding(
            padding: const EdgeInsets.only(
              bottom: 3.0,
              left: 3.0,
              right: 3.0,              
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, 
              children: [
                //PRICE
                Teexts().label(
                  moneda.format(product.price),
                  product.isOffer == true ? 16.0 : 19.0,
                  product.isOffer == true ? Colors.grey : Colors.black
                ),

                //PRICING OFF
                product.isOffer != true ? 
                  SizedBox(height: 0.0)
                  :
                  Row(
                    children: [
                      Teexts().label(moneda.format(product.offPrice), 19.0, Colors.black),
                      
                        SizedBox(width: 3.0),

                      Teexts().label('${product.off}% OFF', 14.0, Colors.green),
                    ],
                  ),
                
                //PRODUCT DESCRIPTION
                Teexts().labelExpanded(
                  text: product.name,
                  color: Colors.black,
                  fontSize: 17.0,
                  maxLines: 2
                )
              ],
            ),
          ),
          
        ],
      ),
    );
  }

}