import 'package:intl/intl.dart';

import 'package:portafolio/src/ecommerceApp/models/a-homeM.dart';
import 'package:portafolio/src/ecommerceApp/models/ac-myAccountM.dart';

import 'package:portafolio/src/widgets/textfield.dart';

import 'package:flutter/material.dart';

class EcommerceAppProductRow {

  //USE IN PAGE AA-SHOPPING-CART | ACAA-STORE-PAGE
  Widget product(ProductInfo product){
    NumberFormat moneda = NumberFormat.simpleCurrency(decimalDigits: 0);

    return Container(
      margin: EdgeInsets.all(6.0),

      child: Row(
        children: [
          Container(
            height: 80.0,
            width: 80.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              image: DecorationImage(
                image: NetworkImage(product.images[0]),
                fit: BoxFit.fill
              )
            ),
          ),

            SizedBox(width: 5.0),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Teexts().labelExpanded(
                  text: product.name,
                  color: Colors.black,
                  fontSize: 18.0,
                  maxLines: 2
                ),

                Teexts().label(
                  product.isOffer == true ? 
                    moneda.format(product.offPrice)
                    :
                    moneda.format(product.price),

                  20.0, 
                  product.isOffer == true ? Colors.green : Colors.black
                )
              ]
            ),
          )
        ]
      ),
    );
  }


  Widget productHistorial(ProductHistorial product){
    NumberFormat moneda = NumberFormat.simpleCurrency(decimalDigits: 0);

    return Container(
      margin: EdgeInsets.all(6.0),

      child: Row(
        children: [
          Container(
            height: 80.0,
            width: 80.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              image: DecorationImage(
                image: NetworkImage(product.images[0]),
                fit: BoxFit.fill
              )
            ),
          ),

            SizedBox(width: 5.0),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Teexts().labelExpanded(
                  text: product.productName,
                  color: Colors.black,
                  fontSize: 18.0,
                  maxLines: 2
                ),

                Teexts().label(
                  product.off == 0 ? 
                    moneda.format(product.offPrice)
                    :
                    moneda.format(product.price),

                  20.0, 
                  product.off == 0 ? Colors.green : Colors.black
                )
              ]
            ),
          )
        ]
      ),
    );
  }

}