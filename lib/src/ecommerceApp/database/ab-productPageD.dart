import 'package:portafolio/src/services/myInfo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:portafolio/src/ecommerceApp/models/a-homeM.dart';
import 'package:portafolio/src/ecommerceApp/models/ab-productPageM.dart';

class EcommerceAppProductPageDatabase {

  String myUserID = MyInfo.myUserID;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<List<ReviewInfo>> getProductReviews(DocumentReference docREF) async{ 

    List<ReviewInfo> allReviews = [];

    await docREF
      .collection('reviews')
      .get().then((documents){
        
        documents.docs.forEach((doc) {
          allReviews.add(ReviewInfo.fromDocSnapshot(doc));
        });

      });

    return allReviews;
  }


  void addProductToFavorite(ProductInfo product) async{

    List<ReviewInfo> reviews = [];

    await product.refDatabaseProduct
      .collection('reviews')
      .get().then((documents){
        documents.docs.forEach((doc) {
          reviews.add(ReviewInfo.fromDocSnapshot(doc));
        });
      });

    await _firestore
      .collection('EcommerceAppUsers')
      .doc(myUserID)
      .collection('myFavoriteProducts')
      .doc(product.productID)
      .set({
        'description': product.description,
        'images': product.images,
        'name': product.name,
        'off': product.off,
        'offPrice': product.offPrice,
        'price': product.price,
        'isOffer': product.isOffer,
        'sizes': product.sizes
      });
    
    await Future.forEach(reviews, (element) async{
      await _firestore
      .collection('EcommerceAppUsers')
      .doc(myUserID)
      .collection('myFavoriteProducts')
      .doc(product.productID)
      .collection('reviews')
      .add({
        'ranking': element.ranking,
        'review': element.review
      });
    });

  }


  void addProductToCart(ProductInfo product) async{

    List<ReviewInfo> reviews = [];

    await product.refDatabaseProduct
      .collection('reviews')
      .get().then((documents){
        documents.docs.forEach((doc) {
          reviews.add(ReviewInfo.fromDocSnapshot(doc));
        });
      });

    await _firestore
      .collection('EcommerceAppUsers')
      .doc(myUserID)
      .collection('myCartProducts')
      .doc(product.productID)
      .set({
        'description': product.description,
        'images': product.images,
        'name': product.name,
        'off': product.off,
        'offPrice': product.offPrice,
        'price': product.price,
        'isOffer': product.isOffer,
        'sizes': product.sizes
      });
    
    Future.forEach(reviews, (element) async{
      await _firestore
      .collection('EcommerceAppUsers')
      .doc(myUserID)
      .collection('myCartProducts')
      .doc(product.productID)
      .collection('reviews')
      .add({
        'ranking': element.ranking,
        'review': element.review
      });
    });
    
  }


}