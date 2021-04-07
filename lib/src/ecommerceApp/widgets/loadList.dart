import 'package:shimmer/shimmer.dart';

import 'package:flutter/material.dart';


class EcommerceAppLoadListGridView extends StatelessWidget {

  final int countShowItems;

  const EcommerceAppLoadListGridView({Key key, this.countShowItems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
      enabled: true,
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
          childAspectRatio: 1/1.3
        ),
        itemCount: countShowItems,
        itemBuilder: (context, index){
          return Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(            
                  child: Container(
                    margin: EdgeInsets.all(5.0),
                    color: Colors.white,
                  )
                ),
          
                Container(
                  height: 15.0,
                  width: 65.0,
                  color: Colors.white,
                ),

                  SizedBox(height: 10.0),

                Container(
                  height: 15.0,
                  width: double.infinity,
                  color: Colors.white,
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}


class EcommerceAppLoadListView extends StatelessWidget {
  const EcommerceAppLoadListView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
      enabled: true,

      child: ListView.builder(
        itemCount:  10,
        itemBuilder: (context, index){
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),

            child: Row(
              children: [
                Container(
                  height: 90.0,
                  width: 90.0,
                  color: Colors.white,
                ),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 20.0,
                        width: 80.0,
                        color: Colors.white,
                        margin: EdgeInsets.all(5.0),
                      ),
                      Container(
                        height: 20.0,
                        width: 100.0,
                        color: Colors.white,
                        margin: EdgeInsets.all(5.0),
                      ),
                      Container(
                        height: 20.0,
                        color: Colors.white,
                        margin: EdgeInsets.all(5.0),
                      ),
                    ]
                  )
                )
              ],
            ),
          );
        }
      ),
    );
  }
}

class LoadProductAmount extends StatelessWidget {
  const LoadProductAmount({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
      enabled: true,

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          
          //PRODUCTS AMOUNT
          Container(
            height: 30.0,
            width: 120.0,
            color: Colors.white,
          ),

          Spacer(),

          //ICON BUTTON TO FILTER PRODUCTS
          Container(
            height: 40.0,
            width: 40.0,
            color: Colors.white,
            margin: EdgeInsets.only(right: 8.0)
          )
        ],
      ),
    );
  }
}


class LoadingOfficialStores extends StatelessWidget {
  const LoadingOfficialStores({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Shimmer.fromColors(
      baseColor: Colors.grey[300],
      highlightColor: Colors.grey[100],
      enabled: true,

      child: Column(
        children: [
          Spacer(),

          Container(
            height: 150.0,
            width: size.width,
            color: Colors.white,
            margin: EdgeInsets.symmetric(horizontal: 10.0),
          ),

            SizedBox(height: 70.0),
          
          Container(
            height: 200.0,
            width: size.width,
            color: Colors.white,
            margin: EdgeInsets.symmetric(horizontal: 10.0),
          )
        ],
      ),
    );
  }
}