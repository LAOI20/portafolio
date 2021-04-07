import 'package:portafolio/src/services/myInfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:portafolio/src/ecommerceApp/models/a-homeM.dart';

class EcommerceAppHomeDatabase {

  String myUserID = MyInfo.myUserID;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<List<Categoriee>> getCategories() async{

    List<Categoriee> categoriesList = [];

    await _firestore
      .collection('EcommerceApp')
      .get().then((documents){

        documents.docs.forEach((doc) {
          categoriesList.add(Categoriee.fromDocSnapshot(doc));
        });

      });
    
    return categoriesList;
  }


  Future<List<ProductInfo>> getMyFavoriteProducts() async{
    
    List<ProductInfo> myFavoriteProducts = [];

    await _firestore
      .collection('EcommerceAppUsers')
      .doc(myUserID)
      .collection('myFavoriteProducts')
      .get().then((documents){
        
        documents.docs.forEach((doc) {
          
          myFavoriteProducts.add(
            ProductInfo.fromDocSnapshot(doc, doc.data()['isOffer'])
          );

        });
      });
    
    return myFavoriteProducts;
  }



  Future<List<ProductInfo>> getMyShoppings() async{
    
    List<ProductInfo> myShoppings = [];

    await _firestore
      .collection('EcommerceAppUsers')
      .doc(myUserID)
      .collection('myShoppings')
      .get().then((documents){
        
        documents.docs.forEach((doc) {
          
          myShoppings.add(
            ProductInfo.fromDocSnapshot(doc, doc.data()['isOffer'])
          );

        });
      });
    
    return myShoppings;
  }


  Future<List<ProductInfo>> getMyCartProducts() async{
    
    List<ProductInfo> myCartProducts = [];

    await _firestore
      .collection('EcommerceAppUsers')
      .doc(myUserID)
      .collection('myCartProducts')
      .get().then((documents){
        
        documents.docs.forEach((doc) {
          
          myCartProducts.add(
            ProductInfo.fromDocSnapshot(doc, doc.data()['isOffer'])
          );

        });
      });
    
    return myCartProducts;
  }



  Future<List<ProductInfo>> getCategorieProductsOffers(String categorieName) async{

    List<ProductInfo> productsOffer = [];
    
    await _firestore
      .collection('EcommerceApp')
      .doc(categorieName)
      .collection('offers')
      .get().then((documents){


        documents.docs.forEach((doc) {
          productsOffer.add(ProductInfo.fromDocSnapshot(doc, true));
        });

      });
    
    return productsOffer;
  }

  Future<List<ProductInfo>> getCategorieTopProducts(String categorieID) async{
   
    List<ProductInfo> topProductss = [];

    await _firestore
      .collection('EcommerceApp')
      .doc(categorieID)
      .collection('topProducts')
      .get().then((documents){

        documents.docs.forEach((doc) {
          topProductss.add(ProductInfo.fromDocSnapshot(doc, false));
        });

      });
    
    return topProductss;
  }


  void addProductHistorial(ProductInfo product){
    _firestore
      .collection('EcommerceAppUsers')
      .doc(MyInfo.myUserID)
      .get().then((doc) async{

        if(doc.data()['lastProductVisit'] != product.productID){
          
          await doc.reference
            .collection('historial')
            .doc(product.productID)
            .set({
              'date': DateTime.now().toString(),
              'description': product.description,
              'images': product.images,
              'name': product.name,
              'off': product.isOffer == true ? product.off : 0,
              'offPrice': product.isOffer == true ? product.offPrice : 0,
              'price': product.price
            });
          
          doc.reference
            .update({
              'lastProductVisit': product.productID
            });
        }
      });
  }

}