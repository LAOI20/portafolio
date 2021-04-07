import 'package:get/state_manager.dart';
import 'package:intl/intl.dart';
import 'package:portafolio/src/services/myInfo.dart';

import 'package:portafolio/src/ecommerceApp/controllers/aba-payProductC.dart';

import 'package:portafolio/src/ecommerceApp/widgets/paymentContainer.dart';
import 'package:portafolio/src/widgets/buttons.dart';
import 'package:portafolio/src/widgets/loadings.dart';
import 'package:portafolio/src/widgets/textfield.dart';

import 'package:flutter/material.dart';


class EcommerceAppPayProduct extends StatelessWidget {
  const EcommerceAppPayProduct({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EcommerceAppPayProductController>(
      init: EcommerceAppPayProductController(),
      builder: (_) {
        return Scaffold(
          body: Stack(
            children: [
              GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),

                  child: SafeArea(
                    child: Column(
                      children: [
                        
                        //PURCHASE INFORMATION
                        _InformationContainer(
                          productName: _.homeController.selectedProduct.name,                      
                          size: _.productController.sizeNameSelect
                        ),

                        _Destination(
                          addressDestination: _.productController.destinationAddress,
                          deliveryDate: _.estimatedDelivery
                        ),

                          SizedBox(height: 20.0),

                        //AMOUNT TO PAY
                        _TotalPrice(
                          shipmentPrice: _.productController.shipmentPrice
                        ),

                          SizedBox(height: 30.0),

                        //CREDIT CARD DETAILS
                        EcommerceAppPaymentContainer(
                          amount: _.totalPrice,
                          loaded: () => _.paymentIntent(false),
                          finished: () => _.paymentIntent(true),
                          products: [_.homeController.selectedProduct],
                          deliveryDate: _.estimatedDelivery,
                          address: _.productController.destinationAddress,
                        )
                      ],
                    ),
                  ),
                ),
              ),

              _.isLoadedPayment == true ?
                Loadings().loadWidgetFullScreen(context)
                :
                SizedBox(height: 0.0)
            ],
          ),
        );
      }
    );
  }
}


class _InformationContainer extends StatelessWidget {

  final String productName;
  final String size;

  const _InformationContainer({Key key, this.productName, this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(width: 4.0, color: Colors.black),
        borderRadius: BorderRadius.all(Radius.circular(20.0))
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Teexts().label(productName,  20.0, Colors.black),

            SizedBox(height: 6.0),
          
          Divider(thickness: 4.0),
          
          size == null ?
            SizedBox(height: 0.0)
            :
            Teexts().label('Talla : $size', 20.0, Colors.black),

            SizedBox(height: 6.0),

          //CHOOSE AMOUNT
          GetBuilder<EcommerceAppPayProductController>(
            id: 'amountContainer',
            builder: (_) {
              return Row(
                children: [
                  Teexts().label('Cantidad : ', 20.0, Colors.black),
                  
                    SizedBox(width: 10.0),
                  
                  Buttons().buttonIcon(Icons.arrow_back_ios, 30.0, () { 
                    _.changeAmount(increment: false);
                  }),
                  
                  Teexts().label(_.amount.toString(), 22.0, Colors.black),              

                    SizedBox(width: 10.0),

                  Buttons().buttonIcon(Icons.arrow_forward_ios, 30.0, () { 
                    _.changeAmount(increment: true);                    
                  }),
                ],
              );
            }
          )
        ],
      ),
    );
  }
}


class _Destination extends StatelessWidget {

  final String addressDestination;
  final String deliveryDate;

  const _Destination({Key key, this.addressDestination, this.deliveryDate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(width: 4.0, color: Colors.black),
        borderRadius: BorderRadius.all(Radius.circular(20.0))
      ),

      child: Column(
        children: [
          Teexts().label('Destino', 21.0, Colors.black),
          Teexts().label(addressDestination, 19.0, Colors.black),

          Divider(thickness: 2.0,),

          Align(
            alignment: Alignment.centerLeft,

            child: Teexts().label('Llega', 21.0, Colors.black),            
          ),
          Align(
            alignment: Alignment.centerLeft,

            child: Teexts().label(deliveryDate, 19.0, Colors.black),            
          ),

        ]
      )
    );
  }
}



class _TotalPrice extends StatelessWidget {
  //FOR NOT USE OTHER GETBUILDER
  final double shipmentPrice;

  const _TotalPrice({Key key, this.shipmentPrice}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NumberFormat moneda = NumberFormat.simpleCurrency(decimalDigits: 0);

    return Container(
      margin: EdgeInsets.all(20.0),
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: MyInfo.isDarkMode != true ?
         Colors.blue : Colors.black45,
         
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            offset: Offset(0, 5.0),
            blurRadius: 40.0,
          )
        ]
      ),

      child: Column(
        children: [                        
          //PRODUCT PRICE
          Row(
            children: [
              Teexts().label('Producto', 20.0, Colors.black),

              Spacer(),

              GetBuilder<EcommerceAppPayProductController>(
                id: 'productPriceContainer',
                builder: (_) {
                  return Teexts().label(
                    moneda.format(_.productPrice),
                    20.0, 
                    Colors.black
                  );
                }
              ),
            ],
          ),

            SizedBox(height: 10.0),

          //SHIPPING PRICE
          Row(
            children: [
              Teexts().label('Envio', 20.0, Colors.black),

              Spacer(),

              Teexts().label(
                moneda.format(shipmentPrice), 
                20.0, 
                Colors.black
              ),
            ],
          ),

          Divider(thickness: 4.0, color: Colors.black),

            SizedBox(height: 8.0),

          //TOTAL
          Row(
            children: [
              Teexts().label('Total', 27.0, Colors.black),

              Spacer(),

              GetBuilder<EcommerceAppPayProductController>(
                id: 'totalPriceContainer',
                builder: (_) {
                  return Teexts().label(
                    moneda.format(_.totalPrice), 
                    27.0, 
                    Colors.black
                  );
                }
              ),
            ],
          ),

            SizedBox(height: 8.0),
        ],
      ),
    );
  }
}