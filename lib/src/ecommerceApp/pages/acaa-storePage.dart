import 'package:portafolio/src/services/myInfo.dart';
import 'package:get/state_manager.dart';

import 'package:portafolio/src/ecommerceApp/models/a-homeM.dart';

import 'package:portafolio/src/ecommerceApp/controllers/acaa-storePageC.dart';

import 'package:portafolio/src/ecommerceApp/widgets/alertDialogs.dart';
import 'package:portafolio/src/ecommerceApp/widgets/loadList.dart';
import 'package:portafolio/src/ecommerceApp/widgets/productRow.dart';
import 'package:portafolio/src/widgets/backgroundImage.dart';
import 'package:portafolio/src/widgets/textfield.dart';

import 'package:flutter/material.dart';


class EcommerceAppStorePage extends StatelessWidget {
  const EcommerceAppStorePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EcommerceAppStorePageController>(
      init: EcommerceAppStorePageController(),
      builder: (_) {
        return Scaffold(
          body: backgroundImage(
            child: Stack(
              children: [
                
                //STORE NAME AND REVIEWS
                _StoreNameAndReviews(
                  storeName: EcommerceAppStorePageController.storeName,
                  soldProducts: _.soldProducts,
                ),

                //LIST PRODUCTS
                _ProductList(
                  loadedList: _.productsList.isNotEmpty,
                  listProducts: _.productsList,
                )
              ],
            ),
          ),
        );
      }
    );
  }
}


class _StoreNameAndReviews extends StatelessWidget {

  final String storeName;
  final int soldProducts;

  const _StoreNameAndReviews({Key key, this.storeName, this.soldProducts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,

      child: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          
          child: Column(
            children: [
                SizedBox(height: 15.0),
              
              Teexts().label(storeName, 30.0, Colors.black),

                SizedBox(height: 15.0),

              Container(
                padding: EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  border: Border.all(width: 3.0, color: Colors.black),
                  borderRadius: BorderRadius.all(Radius.circular(20.0))
                ),

                child: Teexts().label(
                  soldProducts == null ? 
                    '.'
                    :
                    '$soldProducts productos vendidos',
                  20.0, 
                  Colors.white
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


class _ProductList extends StatelessWidget {

  final bool loadedList;
  final List<ProductInfo> listProducts;

  const _ProductList({Key key, this.loadedList, this.listProducts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),

      child: Container(
      height: size.height,
      width: size.width,
      
      child: Container(
        margin: EdgeInsets.only(top: size.height * 0.3),
        decoration: BoxDecoration(
          color: MyInfo.isDarkMode != true ?
            Colors.white : Colors.black45,

          borderRadius: BorderRadius.only(topLeft: Radius.circular(100.0))
        ),

        child: Column(
          children: [

            ////PRODUCTS AMOUNT AND ICON FILTER
            Container(
              height: 90.0,
              alignment: Alignment.center,

              child: loadedList == false ? 
                LoadProductAmount()
                :
                Container(
                  padding: EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    border: Border.all(width: 3.0, color: Colors.black),
                    borderRadius: BorderRadius.all(Radius.circular(20.0))
                  ),

                  child: Teexts().label(
                    '${listProducts.length} productos', 
                    20.0, 
                    Colors.black
                  )
                ),
            ),

            //LIST PRODUCTS
            Expanded(
              child: loadedList == false ? 
                EcommerceAppLoadListView()
                :
                GetBuilder<EcommerceAppStorePageController>(
                  id: 'productsListContainer',
                  builder: (_) {                    
                    return ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemCount: listProducts.length,
                      itemBuilder: (context, index){
                        return GestureDetector(
                          onTap: () => EcommerceAppAlertDialogs().showImages(
                            context, listProducts[index].images
                          ),
                          
                          child: EcommerceAppProductRow().product(
                            listProducts[index]
                          )
                        );
                      }
                    );
                  }
                ),
            ),
          ],
        ),
      ),
    ),
  );
  }
}