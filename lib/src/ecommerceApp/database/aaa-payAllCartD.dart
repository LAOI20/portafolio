import 'package:portafolio/src/services/myInfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EcommerceAppPayAllCartDatabase {

  FirebaseFirestore _firestore = FirebaseFirestore.instance;


  void cleanMyShoppingCart(){
    _firestore
      .collection('EcommerceAppUsers')
      .doc(MyInfo.myUserID)
      .collection('myCartProducts')
      .get().then((documents){
        documents.docs.forEach((element) {
          element.reference.delete();
        });
      });
  }

}