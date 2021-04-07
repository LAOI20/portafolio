import 'package:cloud_firestore/cloud_firestore.dart';

class ProductHistorial {
  String productName;
  int off;
  int offPrice;
  int price;
  String description;
  List images;

  ProductHistorial(
    this.productName,
    this.off,
    this.offPrice,
    this.price,
    this.description,
    this.images
  );

  ProductHistorial.fromDocSnapshot(DocumentSnapshot doc){
    productName = doc.data()['name'];
    off = doc.data()['off'];
    offPrice = doc.data()['offPrice'];
    price = doc.data()['price'];
    description = doc.data()['description'];
    images = doc.data()['images'];
  }

}