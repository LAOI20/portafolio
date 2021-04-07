import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/state_manager.dart';
import 'package:portafolio/src/services/myInfo.dart';

import 'package:portafolio/src/navigation.dart';

import 'package:portafolio/src/ecommerceApp/controllers/a-homeC.dart';

import 'package:portafolio/src/ecommerceApp/pages/ac-myAccount-.dart';
import 'package:portafolio/src/ecommerceApp/pages/ae-MyPostalCode.dart';

import 'package:portafolio/src/ecommerceApp/widgets/bottomSheets.dart';
import 'package:portafolio/src/ecommerceApp/widgets/loadList.dart';
import 'package:portafolio/src/ecommerceApp/widgets/productGridView.dart';
import 'package:portafolio/src/widgets/backgroundImage.dart';
import 'package:portafolio/src/widgets/buttons.dart';
import 'package:portafolio/src/widgets/imagee.dart';
import 'package:portafolio/src/widgets/textfield.dart';

import 'package:flutter/material.dart';


class EcommerceAppHome extends StatelessWidget {
  const EcommerceAppHome({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GetBuilder<EcommerceAppHomeController>(
      init: EcommerceAppHomeController(),
      initState: (state){
        //IN CASE YOU HAVE NOT ENTERED ZIP CODE
        if(MyInfo.myPostalCode == null){

          Future.delayed(Duration(milliseconds: 900), (){
          
            Nav().toBackgroundTransparent(
              EcommerceAppMyPostalCode()
            );

          });
        }
      },

      builder: (_) {
        return Scaffold(
          body: backgroundImage(
            child: SafeArea(

              child: Stack(
                children: [
                  
                  //MAIN VIEW
                  SingleChildScrollView(                  
                    controller: _.scrollController,
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: [
                          SizedBox(height: 30.0),

                        _NewProducts(
                          imagesUrls: _.newProductsImagesUrls,
                        ),

                          SizedBox(height: 30.0),

                        _CategoriesBar(),

                          SizedBox(height: 30.0),

                        _OffersContainer(),

                          SizedBox(height: 40.0),

                        _TopSelling(),

                          SizedBox(height: size.height * 0.12)
                      ],
                    ),
                  ),

                  //BOTTOM BAR
                  Positioned(
                    bottom: 0.0,
                    right: 0.0,
                    left: 0.0,

                    child: FadeTransition(
                      opacity: _.animationBottomBarController,
                      child: ScaleTransition(
                        scale: _.animationBottomBarController,
                        child: _BottomBarContainer()
                      )
                    )
                  )
                  
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}


class _NewProducts extends StatelessWidget {

  final List<String> imagesUrls;

  const _NewProducts({Key key, this.imagesUrls}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Teexts().label('Nuevos productos', 25.0, Colors.black),

          SizedBox(height: 8.0),

        _ShakeTransition(
          duration: Duration(seconds: 3),
          axis: Axis.vertical,
          offset: 150.0,

          child: CarouselSlider.builder(          
            options: CarouselOptions(
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              enlargeCenterPage: true
            ),
            itemCount: imagesUrls.length, 

            itemBuilder: (context, index, ___){
              return ClipRRect(
                borderRadius: BorderRadius.circular(20.0),

                child: Imagee().squareImage(imagesUrls[index])
              );
            }
          ),
        ),
      ],
    );
  }
}


class _CategoriesBar extends StatelessWidget {
  const _CategoriesBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return _ShakeTransition(
      duration: Duration(seconds: 3),
      axis: Axis.horizontal,
      offset: 150.0,

      child: Container(
        height: 90.0,
        width: size.width,
        color: MyInfo.isDarkMode != true ?
          Colors.pink : Colors.black54,

        child: GetBuilder<EcommerceAppHomeController>(
          id: 'categoriesBarContainer',
          builder: (_) {
            return ListView.builder(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: _.categories.length,
              itemBuilder: (context, index){
                return Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),

                    child: GestureDetector(
                      onTap: () => _.onTapCategorie(_.categories[index]),

                      child: Opacity(
                        opacity: _.categorieSelect.name == _.categories[index].name ? 
                          1.0 : 0.4,

                        child: Teexts().label(
                          _.categories[index].name, 
                          
                          _.categorieSelect.name == _.categories[index].name ? 
                            27.0 : 20.0,

                          Colors.black
                        )
                      ),
                    ),
                  ),
                );
              }
            );
          }
        ),
      ),
    );
  }
}


class _OffersContainer extends StatelessWidget {
  const _OffersContainer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return _ShakeTransition(
      duration: Duration(seconds: 3),
      axis: Axis.horizontal,
      offset: 150.0,

      child: GetBuilder<EcommerceAppHomeController>(
        id: 'productsOfferContainer',
        builder: (_) {
          return Container(      
            width: size.width,
            margin: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20.0))
            ),

            child: Column(
              children: [
                Teexts().label('Ofertas', 30.0, Colors.black),

                  SizedBox(height: 10.0),
                
                _.showShimmerList == true ?
                  EcommerceAppLoadListGridView(countShowItems: 4)
                  :
                  GridView.builder(    
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8.0,
                      crossAxisSpacing: 8.0,
                      childAspectRatio: 1/1.3
                    ),
                    itemCount: _.productsOffer.length == 0 ? 
                      _.productsOffer.length
                      :
                      _.productsOffer.length - 2,

                    itemBuilder: (context, index){
                      return GestureDetector(
                        onTap: () => _.navigationProductPage(_.productsOffer[index]),
                        
                        child: EcommerceAppProductGridView().product(
                          context,  _.productsOffer[index],                          
                        )
                      );
                    }
                  ),

                _.showShimmerList == true ?
                  SizedBox(height: 0.0)
                  :
                  Align(
                    alignment: Alignment.bottomRight,

                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),

                      child: Buttons().buttonIcon(Icons.arrow_forward_ios, 50.0, () { 
                        //SEE ALL OFFERS
                        EcommerceAppBottomSheets().showProductsInOffer(context, _.productsOffer);
                      }),
                    ),
                  )
              ],
            )
          );
        }
      ),
    );
  }
}


class _TopSelling extends StatelessWidget {
  const _TopSelling({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      width: size.width,
      margin: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20.0))
      ),

      child: Column(
        children: [
          Teexts().label('Lo mas vendido', 28.0, Colors.black),

            SizedBox(height: 10.0),

          GetBuilder<EcommerceAppHomeController>(
            id: 'topProductsContainer',
            builder: (_) {
              return _.showShimmerList == true ?
                EcommerceAppLoadListGridView(countShowItems: 5)
                :
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8.0,
                    crossAxisSpacing: 8.0,
                    childAspectRatio: 1/1.3
                  ),
                  itemCount: _.listTopProducts.length,

                  itemBuilder: (context, index){
                    return GestureDetector(
                      onTap: () => _.navigationProductPage(_.listTopProducts[index]),
                      
                      child: EcommerceAppProductGridView().product(
                        context, _.listTopProducts[index],
                      )
                    );
                  }
                );
            }
          ),

            SizedBox(height: 10.0)
        ]
      ),
    );
  }
}


class _BottomBarContainer extends StatelessWidget {
  const _BottomBarContainer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: MyInfo.isDarkMode != true ?
          Colors.pink : Colors.black87,
          
        borderRadius: BorderRadius.all(Radius.circular(20.0))
      ),

      child: GetBuilder<EcommerceAppHomeController>(
        id: 'bottomBarContainer',
        builder: (_) {
          return Row(
            children: [
              Expanded(
                child: Buttons().buttonIcon(Icons.favorite, 35.0, () { 
                  _.onTapIconFavorite(context);
                }),
              ),

              Expanded(
                child: Buttons().buttonIcon(Icons.shopping_bag, 35.0, () { 
                  _.onTapIconShoppingBag(context);
                }),
              ),

              Expanded(
                child: Buttons().buttonIcon(Icons.shopping_cart, 35.0, () { 
                  _.onTapIconShoppingCart();
                }),
              ),

              Expanded(
                child: Buttons().buttonIcon(Icons.account_circle, 35.0, () { 
                  Nav().to(EcommerceAppMyAccount());
                }),
              ),
            ],
          );
        }
      ),
    );
  }
}



class _ShakeTransition extends StatelessWidget {

  final Widget child;
  final Duration duration;
  final double offset;
  final Axis axis;

  const _ShakeTransition({Key key, this.child, this.duration, this.offset, this.axis}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      child: child,
      duration: duration,
      curve: Curves.bounceOut,
      tween: Tween(begin: 1.0, end: 0.0),
      builder: (context, value, child){
        return Transform.translate(
          offset: axis == Axis.horizontal ? 
            Offset(
              value * offset,
              0.0
            )
            :
            Offset(
              0.0,
              value * offset
            ),

          child: child,
        );
      }
    );
  }
}
