import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:get/instance_manager.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:portafolio/src/services/myInfo.dart';
import 'package:portafolio/src/services/APImodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:portafolio/src/ecommerceApp/models/a-homeM.dart';

import 'package:portafolio/src/ecommerceApp/controllers/a-homeC.dart';

import 'package:portafolio/src/widgets/textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//USE IN PAGE AAA-PAY-ALL-CART
class EcommerceAppPaymentContainer extends StatefulWidget {

  final int amount;
  final Function loaded;
  final Function finished;
  final List<ProductInfo> products;
  final String deliveryDate;
  final String address;

  const EcommerceAppPaymentContainer({Key key, this.amount, this.loaded, this.finished, this.products, this.deliveryDate, this.address}) : super(key: key);

  @override
  _EcommerceAppPaymentContainerState createState() => _EcommerceAppPaymentContainerState();
}

class _EcommerceAppPaymentContainerState extends State<EcommerceAppPaymentContainer> {
  
  final homeController = Get.find<EcommerceAppHomeController>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvv = '';
  bool isCvvFocus = false;  


  @override
  Widget build(BuildContext context) {    
    return Column(
      children: [
        //CREDIT CARD CONTAINER
        CreditCardWidget(
          height: 170.0,
          cardBgColor: Colors.black,
          cardNumber: cardNumber,
          expiryDate: expiryDate,
          cardHolderName: cardHolderName,
          cvvCode: cvv,
          showBackView: isCvvFocus,
          obscureCardCvv: false,
          obscureCardNumber: false,
          labelCardHolder: 'Nombre titular',
        ),

        //CREDIT CARD FORM
        CreditCardForm(
          cardNumber: cardNumber,
          expiryDate: expiryDate,
          cardHolderName: cardHolderName,
          cvvCode: cvv,
          themeColor: Colors.black,
          formKey: formKey,
          obscureCvv: false,
          obscureNumber: false,
          cvvValidationMessage: 'cvv invalido',
          dateValidationMessage: 'fecha invalida',
          numberValidationMessage: 'numero invalido',
          cardNumberDecoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'numero',              
          ),
          expiryDateDecoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'vence',
          ),
          cvvCodeDecoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'CVV'
          ),
          cardHolderDecoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Nombre titular'
          ),

          onCreditCardModelChange: creditCardChange,
        ),

          SizedBox(height: 10.0),

        //PROCESS PAYMENT
        CupertinoButton(
          onPressed: (){
            FocusScope.of(context).unfocus();

            if(formKey.currentState.validate()){
              widget.loaded();
              paymentIntent();
            }
          },

          color: Colors.black,
          child: Teexts().label('Listo', 22.0, Colors.white) 
        ),

          SizedBox(height: 10.0),
      ],
    );
  }


  void creditCardChange(CreditCardModel card){
    setState(() {
      cardNumber = card.cardNumber;
      expiryDate = card.expiryDate;
      cardHolderName = card.cardHolderName;
      cvv = card.cvvCode;
      isCvvFocus = card.isCvvFocused;
    });
  }


  void paymentIntent(){
    int amountConvert = widget.amount * 100;
    int expMonth = int.parse(expiryDate.substring(0, 2));
    int expYear = int.parse('20${expiryDate.substring(3)}');
    
    APImodel().postHttp(
      'https://stripepaymentapi20.herokuapp.com/paymentIntent',
      body: {
        "amount": amountConvert,
        "cardNumber": cardNumber, 
        "expMonth": expMonth,
        "expYear": expYear,
        "cvc": cvv
      }

    ).then((value){

      successPayment();
    });
  }


  void successPayment(){
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    
    Future.forEach(widget.products, (ProductInfo product){
      
      _firestore
        .collection('EcommerceAppUsers')
        .doc(MyInfo.myUserID)
        .collection('myShoppings')
        .doc(product.productID)
        .set({
          'deliveryDate': widget.deliveryDate,
          'address': widget.address,
          'description': product.description,
          'images': product.images,
          'name': product.name,
          'off': product.off,
          'offPrice': product.offPrice,
          'price': product.price,
          'isOffer': product.isOffer,
          'sizes': product.sizes
        });
      
      homeController.myShoppings.add(product);
    });

    widget.finished();

  }

}
