import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'package:portafolio/src/services/myInfo.dart';

import 'package:portafolio/src/widgets/imagee.dart';
import 'package:portafolio/src/widgets/loadings.dart';
import 'package:portafolio/src/widgets/textfield.dart';

import 'package:flutter/material.dart';


class EcommerceAppPurchaseDetails extends StatefulWidget {

  final String productID;

  const EcommerceAppPurchaseDetails({Key key, this.productID}) : super(key: key);

  @override
  _EcommerceAppPurchaseDetailsState createState() => _EcommerceAppPurchaseDetailsState();
}

class _EcommerceAppPurchaseDetailsState extends State<EcommerceAppPurchaseDetails> {
  
  bool hasData = false;


  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String nameProduct;
  int off;
  int offPrice;
  int price;
  bool isOffer;
  String deliveryDate;
  String address;
  String description;
  List images;


  @override
  void initState() {
    super.initState();

    _firestore
      .collection('EcommerceAppUsers')
      .doc(MyInfo.myUserID)
      .collection('myShoppings')
      .doc(widget.productID)
      .get().then((doc){
        deliveryDate = doc.data()['deliveryDate'];
        address = doc.data()['address'];
        description = doc.data()['description'];
        images = doc.data()['images'];
        nameProduct = doc.data()['name'];
        off = doc.data()['off'];
        offPrice = doc.data()['offPrice'];
        price = doc.data()['price'];
        isOffer = doc.data()['isOffer'];

        setState(() => hasData = true);
      });
  }
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: hasData != true ?
        Loadings().loadWidgetFullScreen(context)
        :
        SingleChildScrollView(
          physics: BouncingScrollPhysics(),

          child: SafeArea(
            child: Column(
              children: [
                //IMAGE AND NAME OF PRODUCT
                _ProductImageName(imageUrl: images[0]),

                //SHIPPING STATUS
                _Dates(
                  deliveryDate: deliveryDate,
                  price: price,
                ),

                  SizedBox(height: 10.0),
              ]
            )
          ),
        ),
    );
  }
}


class _ProductImageName extends StatelessWidget {
  
  final String imageUrl;

  const _ProductImageName({Key key, this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),

      child: Card(
        elevation: 10.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))
        ),

        child: Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20.0))
          ),

          child: Imagee().squareImage(imageUrl)
        ),
      ),
    );
  }
}


class _Dates extends StatelessWidget {

  final String deliveryDate;
  final int price;  

  const _Dates({Key key, this.deliveryDate, this.price}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NumberFormat moneda = NumberFormat.simpleCurrency();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      
      child: Card(
        elevation: 10.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))
        ),

        child: Container(
          padding: EdgeInsets.all(8.0),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20.0))
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              Teexts().label('Llega :', 20.0, Colors.black),

              Teexts().label(deliveryDate, 18.0, Colors.black),

                SizedBox(height: 10.0),

              Teexts().label(
                'Precio : ${moneda.format(price)}', 
                20.0, 
                Colors.black
              ),
            ]
          ),
        ),
      ),
    );
  }
}

