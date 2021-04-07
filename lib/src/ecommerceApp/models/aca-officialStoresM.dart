
import 'package:cloud_firestore/cloud_firestore.dart';

class StoreInfo {
  String id;
  String category;
  String salesMan;
  String logoUrl;
  int soldProducts;

  StoreInfo(
    this.id,
    this.category,
    this.salesMan,
    this.logoUrl,
    this.soldProducts
  );

  StoreInfo.fromDocSnapshot(DocumentSnapshot doc){
    id = doc.id;
    category = doc.data()['name'];
    salesMan = doc.data()['salesMan'];
    logoUrl = doc.data()['logoUrl'];
    soldProducts = doc.data()['soldProducts'];
  }

}