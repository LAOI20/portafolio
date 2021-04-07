import 'package:flutter/rendering.dart';
import 'package:get/state_manager.dart';

import 'package:portafolio/src/navigation.dart';

import 'package:portafolio/src/ecommerceApp/models/a-homeM.dart';

import 'package:portafolio/src/ecommerceApp/database/a-homeD.dart';

import 'package:portafolio/src/ecommerceApp/pages/aa-shoppingCart-.dart';
import 'package:portafolio/src/ecommerceApp/pages/ab-productPage.dart';

import 'package:portafolio/src/ecommerceApp/widgets/bottomSheets.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class EcommerceAppHomeController extends GetxController with SingleGetTickerProviderMixin{
  

  ScrollController scrollController;
  
  AnimationController animationBottomBarController;


  List<String> newProductsImagesUrls = [
    'https://firebasestorage.googleapis.com/v0/b/to-home-1416d.appspot.com/o/newProduct1.jpg?alt=media&token=9a1dd42f-db79-48bf-92f9-1d7006f7de6b',
    'https://firebasestorage.googleapis.com/v0/b/to-home-1416d.appspot.com/o/newProduct2.jpg?alt=media&token=3855baff-101c-4ff6-933d-5e78907ede43',
    'https://firebasestorage.googleapis.com/v0/b/to-home-1416d.appspot.com/o/newProduct3.jpg?alt=media&token=04d2b0c1-827a-4ffd-9e54-6f2426a5228a'
  ];


  List<Categoriee> categories = [];
  Categoriee categorieSelect;


  List<ProductInfo> productsOffer = [];


  List<ProductInfo> listTopProducts = [];


  List<ProductInfo> myFavoritesProducts = [];


  List<ProductInfo> myShoppings = [];


  List<ProductInfo> myCartProducts = [];


  ProductInfo selectedProduct;


  bool showShimmerList = true;

  

  @override
  void onInit() {
    super.onInit();       
    
    //GET DATA FROM DATABASE
    //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    EcommerceAppHomeDatabase().getCategories().then((value){
      categories = value;
      categorieSelect = value.first;

    }).then((value) async{

      await EcommerceAppHomeDatabase().getMyFavoriteProducts()
        .then((value){
          myFavoritesProducts = value;
        });

      await EcommerceAppHomeDatabase().getMyShoppings()
        .then((value){
          myShoppings = value;
        });

      await EcommerceAppHomeDatabase().getMyCartProducts()
        .then((value){
          myCartProducts = value;
        });

      await EcommerceAppHomeDatabase().getCategorieTopProducts(categories[0].id)
        .then((value){          
          listTopProducts = value;          
        });

      await EcommerceAppHomeDatabase().getCategorieProductsOffers(categories[0].id)
        .then((productsList){
          
          productsOffer = productsList;

            showShimmerList = false;

            update([
              'productsOfferContainer',
              'topProductsContainer',
              'categoriesBarContainer'
            ]);
        });
    });
    //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


    //TO ANIMATE THE BOTTOM APP BAR WITH SCROLL CONTROLLER
    //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    animationBottomBarController = AnimationController(
      vsync: this,
      value: 1.0,
      duration: Duration(milliseconds: 300)
    );

    scrollController = ScrollController();
    scrollController.addListener(() {
      switch (scrollController.position.userScrollDirection) {
        case ScrollDirection.forward:
          animationBottomBarController.forward();
          break;
        case ScrollDirection.reverse:        
          animationBottomBarController.reverse();
          break;
        default:
      }
      return scrollController;
    });
    //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

  }


  @override
  void onClose() {
    animationBottomBarController.dispose();
    scrollController.dispose();

    super.onClose();
  }

  



  void onTapCategorie(Categoriee onTapCategorie) async{
    
    if(categorieSelect != onTapCategorie){
    
      categorieSelect = onTapCategorie;
      update(['categoriesBarContainer']);

      showShimmerList = true;
      update(['productsOfferContainer', 'topProductsContainer']);     

      await EcommerceAppHomeDatabase().getCategorieTopProducts(onTapCategorie.id)
        .then((valueList){
          listTopProducts = valueList;
        });

      await EcommerceAppHomeDatabase().getCategorieProductsOffers(onTapCategorie.id)
        .then((listValue){
          productsOffer = listValue;

          showShimmerList = false;
          update(['productsOfferContainer', 'topProductsContainer']);
        });

    } else {
      print('no pasara nada');
    }
  }
  


  void navigationProductPage(ProductInfo product){
   
    selectedProduct = product;

    EcommerceAppHomeDatabase().addProductHistorial(product);

    Nav().to(EcommerceAppProductPage());
  }


  //SHOW MY FAVORITE PRODUCTS
  void onTapIconFavorite(BuildContext context){
    EcommerceAppBottomSheets().showFavorites(
      context, myFavoritesProducts
    );    
  }


  //SHOW MY SHOPPINGS
  void onTapIconShoppingBag(BuildContext context){
    EcommerceAppBottomSheets().showMyShopping(
      context, myShoppings
    );
  }


  //NAVIGATION TO MY CART PAGE
  void onTapIconShoppingCart(){
    Nav().to(EcommerceAppShoppingCart());
  }
  

}