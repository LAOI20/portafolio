
import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewInfo {
  String review;
  int ranking;

  ReviewInfo(
    this.review,
    this.ranking
  );

  ReviewInfo.fromDocSnapshot(DocumentSnapshot doc){
    review = doc.data()['review'];
    ranking = doc.data()['ranking'];
  }
}