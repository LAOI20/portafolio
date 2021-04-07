import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:portafolio/src/services/myInfo.dart';

import 'package:portafolio/src/ecommerceApp/models/ac-myAccountM.dart';


class EcommerceAppMyAccountDatabase {

  FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<List<ProductHistorial>> getMyHistorial() async{
    List<ProductHistorial> productsList = [];
    
    await _firestore
      .collection('EcommerceAppUsers')
      .doc(MyInfo.myUserID)
      .collection('historial')
      .orderBy('date', descending: true)
      .get().then((documents){
        documents.docs.forEach((doc) {
          productsList.add(ProductHistorial.fromDocSnapshot(doc));
        });
      });
    
    return productsList;
  }


}