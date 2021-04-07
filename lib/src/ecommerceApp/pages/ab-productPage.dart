import 'package:get/state_manager.dart';
import 'package:intl/intl.dart';
import 'package:portafolio/src/services/myInfo.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:portafolio/src/navigation.dart';

import 'package:portafolio/src/ecommerceApp/controllers/ab-productPageC.dart';
import 'package:portafolio/src/ecommerceApp/controllers/acaa-storePageC.dart';

import 'package:portafolio/src/ecommerceApp/pages/acaa-storePage.dart';

import 'package:portafolio/src/ecommerceApp/widgets/alertDialogs.dart';
import 'package:portafolio/src/ecommerceApp/widgets/bottomSheets.dart';
import 'package:portafolio/src/widgets/backgroundImage.dart';
import 'package:portafolio/src/widgets/buttons.dart';
import 'package:portafolio/src/widgets/imagee.dart';
import 'package:portafolio/src/widgets/textfield.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class EcommerceAppProductPage extends StatelessWidget {

  const EcommerceAppProductPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EcommerceAppProductPageController>( 
      init: EcommerceAppProductPageController(),
      builder: (_) {
        return Scaffold(
          body: backgroundImage(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),

              child: SafeArea(

                child: Column(
                  children: [ 
                      SizedBox(height: 10.0),
                    
                    //MAIN CARD
                    Card(
                      elevation: 10.0,
                      margin: EdgeInsets.all(15.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20.0))
                      ),

                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20.0))
                        ),
                        child: Column(
                          children: [
                            //ICON BUTTON ADD TO FAVORITE OR CART
                            _IconsAdd(),

                            //PRODUCT NAME
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: 8.0,
                                left: 6.0,
                                right: 6.0
                              ),

                              child: Teexts().label(
                                _.homeController.selectedProduct.name,
                                21.0, 
                                Colors.black
                              ),
                            ),

                            //PRODUCT IMAGES
                            _Images(
                              images: _.homeController.selectedProduct.images
                            ),

                            //PRICE AND OFFER PRICE
                            _Prices(
                              price: _.homeController.selectedProduct.price,                              
                              off: _.homeController.selectedProduct.off,
                              offPrice: _.homeController.selectedProduct.offPrice
                            ),

                            //CHOOSE SIZE
                            _.avaibleSizes == null?
                              SizedBox(height: 0.0)
                              :
                              _ChooseSize(
                                sizes: _.homeController.selectedProduct.sizes
                              ),

                            //CHOOSE FEDEX OR ESTAFETA
                            _ChooseShipment(),

                              SizedBox(height: 20.0)
                          ]
                        ),
                      ),
                    ),

                      SizedBox(height: 10.0),
                    
                    //SOLD BY
                    _SoldBy(
                      salesMan: _.homeController.categorieSelect.salesMan
                    ),

                      SizedBox(height: 20.0),

                    //BUY NOW
                    _BuyNowButton(),

                      SizedBox(height: 15.0),

                    //PRODUCT DESCRIPTION
                    _ProductDescription(
                      productDescription: _.homeController.selectedProduct.description
                    ),

                    //REVIEWS
                    _ReviewsContainer(),

                      SizedBox(height: 10.0)
                  ]
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}


class _IconsAdd extends StatelessWidget {
  
  const _IconsAdd({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EcommerceAppProductPageController>(
      id: 'iconsContainer',
      builder: (_) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [          
            IconButton(
              icon: Icon( _.isFavorite == true ?
                Icons.favorite
                :
                Icons.favorite_border
              ),
              color: _.isFavorite == true ? Colors.red : Colors.black,
              iconSize: 30.0,
              onPressed: _.isFavorite == true ? 
                (){}
                :
                () => _.addToFavorite(
                  context, _.homeController.selectedProduct
                )
            ),

              SizedBox(width: 6.0),

            _.isCartProduct == true ?
              SizedBox(height: 0.0)
              :
              IconButton(
                icon: Icon(Icons.add_shopping_cart_outlined),
                color: Colors.black,
                iconSize: 30.0,
                onPressed: () => _.addToCart(
                  context, _.homeController.selectedProduct
                )
              ),

              SizedBox(width: 6.0),
          ],
        );
      }
    );
  }
}


class _Images extends StatelessWidget {

  final List images;

  const _Images({Key key, this.images}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: (){ EcommerceAppAlertDialogs().showImages(context, images); },
      
      child: Container(
        width: size.width,

        child: CarouselSlider.builder(
          options: CarouselOptions(
            enableInfiniteScroll: false,
            enlargeCenterPage: true,
            enlargeStrategy: CenterPageEnlargeStrategy.height
          ),
          itemCount: images.length,
          itemBuilder: (context, index, _){
            return ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              
              child: Imagee().squareImage(images[index])
            );
          }
        ),
      ),
    );
  }
}


class _Prices extends StatelessWidget {

  final int price;
  final int off;
  final int offPrice;

  const _Prices({Key key, this.price, this.off, this.offPrice}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final moneda = NumberFormat.simpleCurrency(decimalDigits: 0);

    return Padding(
      padding: const EdgeInsets.all(15.0),

      child: Column(
        children: [
          
          Align(
            alignment: Alignment.centerLeft,
            
            child: Teexts().label(
              moneda.format(price), 
              off == null ? 23.0 : 20.0,
              off == null ? Colors.black : Colors.grey
            )
          ),

          off == null ? 
            SizedBox(height: 0.0)
            :
            Row(
              children: [
                Teexts().label(moneda.format(offPrice), 23.0, Colors.black),

                  SizedBox(width: 10.0),

                Teexts().label('$off% OFF', 18.0, Colors.green),
              ],
            )
        ]
      ),
    );
  }
}


class _ChooseSize extends StatelessWidget {

  final List sizes;

  const _ChooseSize({Key key, this.sizes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
          SizedBox(height: 25.0),

        Padding(
          padding: EdgeInsets.only(
            bottom: 8.0,
            left: 20.0, 
            right: 20.0
          ),

          child: Teexts().label('Elegir Talla', 22.0, Colors.blue[600]),
        ),

        Container(
          height: 60.0,
          width: size.width,

          child: GetBuilder<EcommerceAppProductPageController>(
            id: 'sizesGuideContainer',
            builder: (_) {
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: sizes.length,
                itemBuilder: (context, index){
                  return Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(horizontal: 30.0),

                    child: GestureDetector(
                      onTap: () => _.onTapSize(index, sizes[index]),

                      child: Opacity(
                        opacity: _.selectSize == index ? 1.0 : 0.4,

                        child: Teexts().label(
                          sizes[index], 
                          _.selectSize == index ? 20.0 : 15.0,
                          Colors.black,
                          fontWeight: _.selectSize == index ? 
                            FontWeight.w800
                            :
                            FontWeight.normal
                        )
                      ),
                    ),
                  );
                }
              );
            }
          ),
        )
      ],
    );
  }
}


class _ChooseShipment extends StatelessWidget {
  const _ChooseShipment({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EcommerceAppProductPageController>(
      id: 'chooseShipmentContainer',
      builder: (_) {
        return Column(
          children: [
            Teexts().label('Elige paqueteria', 21.0, Colors.blue),
                              
            CheckboxListTile(
              value: _.checkBoxsList[0],
              controlAffinity: ListTileControlAffinity.leading,
              title: Teexts().label('Fedex', 20.0, Colors.black),
              onChanged: (value) => _.selectCheckBox(0)
            ),

            CheckboxListTile(
              value: _.checkBoxsList[1],
              controlAffinity: ListTileControlAffinity.leading,
              title: Teexts().label('Estafeta', 20.0, Colors.black),
              onChanged: (value) => _.selectCheckBox(1)
            ),
          ],
        );
      }
    );
  }
}


class _SoldBy extends StatelessWidget {

  final String salesMan;

  const _SoldBy({Key key, this.salesMan}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){ 
        EcommerceAppStorePageController.storeName = salesMan;
        
        Nav().to(EcommerceAppStorePage()); 
      },

      child: Card(
        elevation: 20.0,
        margin: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))
        ),

        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(        
            borderRadius: BorderRadius.all(Radius.circular(20.0))
          ),

          child: Row(
            children: [
              Spacer(),
              //SELLER NAME
              Column(
                children: [
                  Teexts().label('Vendido por', 21.0, Colors.black),

                  Teexts().label(salesMan, 21.0, Colors.black),                      
                ]
              ),

              Spacer(),

              Icon(Icons.arrow_forward_ios, size: 30.0)
            ],
          ),
        ),
      ),
    );
  }
}


class _BuyNowButton extends StatelessWidget {
  const _BuyNowButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GetBuilder<EcommerceAppProductPageController>(
      id: 'buttonBuyNowContainer',
      builder: (_) {
        return AnimatedCrossFade(
          duration: Duration(milliseconds: 500),
          
          crossFadeState: _.onPresButtonBuyNow != true ?
            CrossFadeState.showFirst
            :
            CrossFadeState.showSecond,

          firstChild: CupertinoButton(                
            onPressed: () => _.onTapBuyNowButton(),
            
            color: MyInfo.isDarkMode != true ? 
              Colors.pink : Colors.black,
              
            padding: EdgeInsets.only(
              top: 20.0,
              bottom: 20.0,
              right: size.width * 0.2,
              left: size.width * 0.2
            ),

            child: Teexts().label('Comprar ahora', 25.0, Colors.black),
          ),

          secondChild: Container(  
            height: 60.0,        
            width: 60.0,
            decoration: BoxDecoration(
              color: Colors.pink,
              shape: BoxShape.circle
            ),

            child: Padding(
              padding: const EdgeInsets.all(8.0),

              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          ),

          layoutBuilder: (topChild, topChildKey, bottomChild,bottomChildKey){
            return Stack(
              clipBehavior: Clip.none, 
              alignment: Alignment.center,
              children: [
                Positioned(
                  key: bottomChildKey,
                  top: 0,
                  child: bottomChild
                ),

                Positioned(
                  key: topChildKey,
                  child: topChild
                )
              ],
            );
          }
           
        );
      }
    );
  }
}



class _ProductDescription extends StatelessWidget {

  final String productDescription;

  const _ProductDescription({Key key, this.productDescription}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15.0),
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        border: Border.all(width: 4.0, color: Colors.black),
        borderRadius: BorderRadius.all(Radius.circular(20.0))
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Teexts().label('Descripcion', 30.0, Colors.black),

            SizedBox(height: 15.0),

          Teexts().label(
            productDescription, 
            20.0, 
            Colors.black
          ),
        ]
      )
    );
  }
}


class _ReviewsContainer extends StatelessWidget {
  const _ReviewsContainer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15.0),
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        border: Border.all(width: 4.0, color: Colors.black),
        borderRadius: BorderRadius.all(Radius.circular(20.0))
      ),

      child: Column(
        children: [
          Teexts().label('Opiniones', 30.0, Colors.black),

          Row(
            children: [
              Spacer(),

              Icon(Icons.star, size: 40.0, color: Colors.amber),

                SizedBox(width: 5.0),

              GetBuilder<EcommerceAppProductPageController>(
                id: 'reviewsContainer',
                builder: (_) {
                  return Teexts().label(
                    _.averageReviews.toString().substring(0, 3),                    
                    25.0, 
                    Colors.black
                  );
                }
              ),

              Spacer(),

              Buttons().buttonIcon(Icons.arrow_forward_ios, 35.0, () { 
                EcommerceAppBottomSheets().showReviewsProduct(context);
              })
            ]
          )
        ]
      ),
    );
  }
}