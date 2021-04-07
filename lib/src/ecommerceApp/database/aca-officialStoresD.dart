import 'package:portafolio/src/ecommerceApp/models/aca-officialStoresM.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EcommerceAppOfficialStoresDatabase {


  FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<List<StoreInfo>> getStoresInfo() async{

    List<StoreInfo> stores = [];

    await _firestore
      .collection('EcommerceApp')
      .get().then((documents){

        documents.docs.forEach((doc) {
          stores.add(StoreInfo.fromDocSnapshot(doc));
        });

      });

    return stores;
  }

}