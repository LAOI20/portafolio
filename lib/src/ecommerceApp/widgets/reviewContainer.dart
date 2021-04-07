
import 'package:portafolio/src/ecommerceApp/models/ab-productPageM.dart';

import 'package:portafolio/src/widgets/textfield.dart';

import 'package:flutter/material.dart';

class EcommerceAppReviewContainer {

  //USE IN BOTTOM SHEET OF PAGE AB-PRODUCT-PAGE
  Widget container(ReviewInfo review){
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
            SizedBox(height: 5.0),

          Row(
            children: [
              Icon(Icons.star, size: 30.0, color: Colors.amber),

                SizedBox(width: 5.0),

              Teexts().label(review.ranking.toString(), 20.0, Colors.black)
            ]
          ),

          Teexts().label(
            review.review,
            20.0, 
            Colors.black
          ),

            SizedBox(height: 5.0),

          Divider(thickness: 4.0,)
        ]
      ),
    );
  }

}