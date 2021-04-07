import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';


class MoviesAppLoadList {


  Widget moviesLoadList(){
    return SingleChildScrollView(
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[100],
        enabled: true,

        child: Column(
          children: [
            Container(
              height: 270.0,
              width: 200.0,
              margin: EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 15.0
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20.0))
              ),
            ),

            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 6,

              itemBuilder: (context, index) {
                return Container(
                  height: 40.0,
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 12.0
                  ),
                  decoration: BoxDecoration(   
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20.0)), 
                  ),
                );
              }
            )
          ],
        ),
      ),
    );
  }

}