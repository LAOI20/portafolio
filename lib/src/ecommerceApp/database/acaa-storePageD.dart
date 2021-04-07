import 'package:portafolio/src/ecommerceApp/models/a-homeM.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EcommerceAppStorePageDatabase {

  FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<int> getSoldProducts(String storeName) async{
    
    int result; 

    QuerySnapshot storeDoc = await _firestore
      .collection('EcommerceApp')
      .where('salesMan', isEqualTo: storeName)
      .get();
    
    await storeDoc.docs[0].reference
      .get().then((value){
        result = value.data()['soldProducts'];
      });

    return result; 
  }


  Future<List<ProductInfo>> getStoreProducts(String storeName) async{

    List<ProductInfo> productsList = [];

    QuerySnapshot storeDoc = await _firestore
      .collection('EcommerceApp')
      .where('salesMan', isEqualTo: storeName)
      .get();
    
    await storeDoc.docs[0].reference
      .collection('offers')
      .get().then((documents){
        documents.docs.forEach((doc) {
          productsList.add(ProductInfo.fromDocSnapshot(doc, true));
        });
      });
    
    await storeDoc.docs[0].reference
      .collection('topProducts')
      .get().then((documents){
        documents.docs.forEach((doc) {
          productsList.add(ProductInfo.fromDocSnapshot(doc, false));          
        });
      });

    return productsList;
  }
} 