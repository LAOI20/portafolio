import 'package:get/state_manager.dart';
import 'package:intl/intl.dart';

import 'package:portafolio/src/ecommerceApp/controllers/aaa-payAllCartC.dart';

import 'package:portafolio/src/ecommerceApp/widgets/paymentContainer.dart';
import 'package:portafolio/src/widgets/loadings.dart';
import 'package:portafolio/src/widgets/textfield.dart';

import 'package:flutter/material.dart';


class EcommerceAppPayAllCart extends StatelessWidget {
  const EcommerceAppPayAllCart({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EcommerceAppPayAllCartController>(
      init: EcommerceAppPayAllCartController(),
      builder: (_) {
        return Scaffold(
          body: _.loadedData == false ?
            Loadings().loadWidgetInBottomSheet()
            :
            Stack(
              children: [
                GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),

                    child: SafeArea(
                      child: Column(
                        children: [
                            SizedBox(height: 10.0),
                          
                          _InfoShipment(
                            deliveryDate: _.estimatedDelivery,
                            addressDestination: _.addressDestination,
                            priceShipment: _.shipmentPrice.toInt(),
                            priceTotal: _.shoppingCartController.totalPriceProducts,
                          ),

                            SizedBox(height: 20.0),

                          EcommerceAppPaymentContainer(
                            amount: _.shipmentPrice.toInt() + _.shoppingCartController.totalPriceProducts,
                            loaded: () => _.paymentIntentLoaded(false),
                            finished: () => _.paymentIntentLoaded(true),
                            products: _.homeController.myCartProducts,
                            deliveryDate: _.estimatedDelivery,
                            address: _.addressDestination
                          )
                        ]
                      )
                    )
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


class _InfoShipment extends StatelessWidget {

  final String deliveryDate;
  final String addressDestination;
  final int priceShipment;
  final int priceTotal;

  const _InfoShipment({Key key, this.deliveryDate, this.addressDestination, this.priceShipment, this.priceTotal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final moneda = NumberFormat.simpleCurrency(decimalDigits: 0);
    int priceTotalAndShipment = priceTotal + priceShipment;

    return Container(
      padding: EdgeInsets.all(10.0),

      child: Card(
        elevation: 10.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))
        ),

        child: Padding(
          padding: const EdgeInsets.all(8.0),
          
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //DELIVERY DATE
              Row(
                children: [
                  Teexts().label('Llega', 20.0, Colors.black),

                  Spacer(),

                  Teexts().label(deliveryDate, 20.0, Colors.black),
                ],
              ),

              Divider(thickness: 4.0),

              //DESTINY ADDRESS
              addressDestination != null ?
                Teexts().label('Destino :', 20.0, Colors.black)
                :
                SizedBox(height: 0.0),
              
              addressDestination != null ?
                Teexts().label(addressDestination, 20.0, Colors.black)
                :
                SizedBox(height: 0.0),
              

              Divider(thickness: 4.0),

                SizedBox(height: 20.0),

              //SHIPMENT PRICE
              Row(
                children: [
                  Teexts().label('Envio', 20.0, Colors.black),

                  Spacer(),

                  Teexts().label(
                    moneda.format(priceShipment), 
                    20.0, 
                    Colors.black
                  ),
                ],
              ),

                SizedBox(height: 10.0),

              //PRICE TOTAL
              Row(
                children: [
                  Teexts().label('Total', 20.0, Colors.black),

                  Spacer(),

                  Teexts().label(
                    moneda.format(priceTotalAndShipment), 
                    20.0, 
                    Colors.black
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}