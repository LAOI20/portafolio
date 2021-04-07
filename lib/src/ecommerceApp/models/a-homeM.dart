
import 'package:cloud_firestore/cloud_firestore.dart';


class Categoriee {
  String id;
  String name;
  String salesMan;
  int soldProducts;

  Categoriee(
    this.id,
    this.name,
    this.salesMan,
    this.soldProducts
  );

  Categoriee.fromDocSnapshot(DocumentSnapshot doc){
    id = doc.id;
    name = doc.data()['name'];
    salesMan = doc.data()['salesMan'];
    soldProducts = doc.data()['soldProducts'];
  }

}


class ProductInfo {
  String productID;
  String name;
  String description;
  bool isOffer;
  int price;
  int off;
  int offPrice;
  List sizes = [];
  List images = [];
  DocumentReference refDatabaseProduct;

  ProductInfo(
    this.productID,
    this.name,
    this.description,
    this.isOffer,
    this.price,
    this.off,
    this.offPrice,
    this.sizes,
    this.images,
    this.refDatabaseProduct
  );

  ProductInfo.fromDocSnapshot(DocumentSnapshot doc,bool isOfferProduct){
    productID = doc.id;
    name = doc.data()['name'];
    description = doc.data()['description'];
    isOffer = isOfferProduct;
    price = doc.data()['price'];
    off = doc.data()['off'];
    offPrice = doc.data()['offPrice'];
    sizes = doc.data()['sizes'];
    images = doc.data()['images'];
    refDatabaseProduct = doc.reference;
  }

}
