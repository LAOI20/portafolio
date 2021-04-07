import 'package:portafolio/src/services/APImodel.dart';
import 'package:get/state_manager.dart';

import 'package:portafolio/src/navigation.dart';

import 'package:portafolio/src/moviesApp/database/a-homeD.dart';

import 'package:portafolio/src/moviesApp/models/a-homeM.dart';

import 'package:portafolio/src/moviesApp/pages/ab-movieInfo.dart';

import 'package:portafolio/src/moviesApp/widgets/bottomSheets.dart';

import 'package:flutter/material.dart';


class MoviesAppHomeController extends GetxController with SingleGetTickerProviderMixin{

  
  bool dataLoaded = false;

  bool isLoadedMovieImages;


  AnimationController premieresAnimation;

  AnimationController moviesAnimation;
  Animation sizeTransition;


  List<String> premieresNames = [
    'el cadaver', 'vivo', 'interstellar', 'hansel y gretel'
  ];

  List<MovieInfo> premieresList = [];

  //IS NECCESARY BECAUSE ON TAP PREMIER ADD IMAGES TO ARRAY
  Map<String, dynamic> premieresImagesUrls = {
    'el cadaver': ['https://firebasestorage.googleapis.com/v0/b/to-home-1416d.appspot.com/o/el%20cadaver%2Fimage1.jpg?alt=media&token=364da0c6-4791-43c2-90c5-44ce61764d1a'],
    'vivo': ['https://firebasestorage.googleapis.com/v0/b/to-home-1416d.appspot.com/o/vivo%2Fimage1.jpg?alt=media&token=f171101c-3b17-4c88-83aa-65a0c67183ce'],
    'interstellar': ['https://firebasestorage.googleapis.com/v0/b/to-home-1416d.appspot.com/o/interstellar%2Finterstellar2.jpg?alt=media&token=01cf0853-871b-454f-a722-cb5e1603a4e6'],
    'hansel y gretel': ['https://firebasestorage.googleapis.com/v0/b/to-home-1416d.appspot.com/o/hansel%20y%20gretel%2Fimage1.jpg?alt=media&token=80a777b3-39ca-4f44-a67b-53190f30031d'],
  };

  Map<String, dynamic> premieresTrailersUrls = {
    'el cadaver': 'E2qDMwNfhUk',
    'vivo': 'skH9L6kAdD4',
    'interstellar': 'NqniWGlg5kU',
    'hansel y gretel': 'MvlT8OEjVM',
  };



  List<String> moviesNames = [
    'insidious', 'avengers', 'the matrix', 'in time',
    'steve jobs', 'focus'
  ];

  List<MovieInfo> moviesList = [];
  
  List<Map<String, dynamic>> moviesImagesUrls = [
    {'movie': 'insidious', 'imagesUrls': [] },
    {'movie': 'avengers', 'imagesUrls': [] },
    {'movie': 'the matrix', 'imagesUrls': [] },
    {'movie': 'in time', 'imagesUrls': [] },
    {'movie': 'steve jobs', 'imagesUrls': [] },
    {'movie': 'focus', 'imagesUrls': [] },
  ];


  int tabBarSelect = 0;



  @override
  void onInit() {
    super.onInit();

    moviesAnimation = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2200)
    );

    APImodel().getMoviesData(premieresNames).then((premieresValue){
      premieresList = premieresValue;

    }).then((value){

      APImodel().getMoviesData(moviesNames).then((moviesValue){
        
        moviesList = moviesValue;

        dataLoaded = true;

        moviesAnimation.forward();

        update();
        
      });
    });

  }


  @override
  void onClose() {
    
    moviesAnimation.dispose();
    
    super.onClose();
  }


  void onTapPremier(String premierName,MovieInfo movie,String videoUrl){

    if(premieresImagesUrls[premierName].length == 1){
      
      MoviesAppHomeDatabase().getMovieImagesUrls(premierName)
        .then((value){
          
          premieresImagesUrls[premierName] = value;

          update(['pageMovieInfo']);
        });
    }

    Nav().toBackgroundTransparent(
      MoviesAppMovieInfo(
        premiereName: premierName,
        movie: movie,
        trailerUrl: videoUrl,
      )
    );
  }



  void onTapMovieCard(BuildContext context,int index){
    
    MoviesAppBottomSheets().showMovieImages(
      context, 
      index,
      moviesList[index]
    );

    //CHECK IF THE IMAGES OF THIS MOVIE ARE ALREADY LOADED
    if(moviesImagesUrls[index]['imagesUrls'].length == 0){
      
      isLoadedMovieImages = false;
      print('si entra');

      MoviesAppHomeDatabase().getMovieImagesUrls(moviesNames[index])
        .then((value){
          moviesImagesUrls[index]['imagesUrls'] = value;

          isLoadedMovieImages = true;
          update(['bottomSheetContainer']);
        }); 
    }

  }


  void onTapBottomSheetTabBar(int index){    
    tabBarSelect = index;
    update(['bottomSheetContainer']);
  }
  
}