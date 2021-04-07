import 'dart:ui';
import 'package:get/state_manager.dart';
import 'package:portafolio/src/moviesApp/models/a-homeM.dart';
import 'package:portafolio/src/services/myInfo.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:portafolio/src/navigation.dart';

import 'package:portafolio/src/moviesApp/controllers/a-homeC.dart';

import 'package:portafolio/src/moviesApp/pages/aba-seeVideo.dart';

import 'package:portafolio/src/widgets/buttons.dart';
import 'package:portafolio/src/widgets/imagee.dart';
import 'package:portafolio/src/widgets/loadings.dart';
import 'package:portafolio/src/widgets/textfield.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class MoviesAppMovieInfo extends StatelessWidget {

  final String premiereName;
  final MovieInfo movie;
  final String trailerUrl;

  const MoviesAppMovieInfo({this.premiereName, this.movie, this.trailerUrl});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MoviesAppHomeController>(
      id: 'pageMovieInfo',
      builder: (_) {
        List imagesUrls = _.premieresImagesUrls[premiereName];        

        return Scaffold(
          backgroundColor: Colors.transparent,

          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),

            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            
              child: SafeArea(
                child: imagesUrls.length == 1 ?
                  Loadings().loadWidgetFullScreen(context)
                  :
                  Column(
                    children: [
                      //BACK BOTTON
                      Align(
                        alignment: Alignment.topLeft,

                        child: Buttons().buttonIcon(Icons.cancel, 50.0, () { 
                          Nav().back();
                        },
                          color: MyInfo.isDarkMode != true ?
                            Colors.white : Colors.black
                        ),
                      ),

                        SizedBox(height: 10.0),

                      //MOVIE IMAGES
                      CarouselSlider.builder(
                        options: CarouselOptions(
                          autoPlay: true,
                          autoPlayInterval: Duration(seconds: 2),
                          enlargeCenterPage: true,
                        ),
                        itemCount: imagesUrls.length, 

                        itemBuilder: (context, index, __){
                          return Container(
                            width: double.infinity,

                            child: ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(20.0)),

                              child: Imagee().squareImage(
                                _.premieresImagesUrls[premiereName][index],
                              )
                            ),
                          );
                        }
                      ),

                        SizedBox(height: 20.0),
                      
                      //STARS
                      _Ranking(),

                        SizedBox(height: 10.0),

                      //SYNOPSIS CONTAINER
                      _Synopsis(
                        sypnosis: movie.plot,
                      ),

                        SizedBox(height: 100.0),
                    ],
                  ),
              ),
            ),
          ),

          floatingActionButton: imagesUrls.length == 1 ?
            SizedBox(height: 0.0,)
            :
            FloatingActionButton.extended(
              backgroundColor: Colors.black,
              label: Teexts().label('Trailer', 22.0, Colors.white),

              onPressed: (){
                Nav().to(MoviesAppSeeVideo(videoUrl: trailerUrl));
              }
            ),
        );
      }
    );
  }
}


class _Ranking extends StatelessWidget {
  const _Ranking({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: MyInfo.isDarkMode != true ?
          Colors.white : Colors.black54,

        border: Border.all(color: Colors.amber, width: 5.0),
        borderRadius: BorderRadius.all(Radius.circular(20.0)),         
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star, size: 40.0, color: Colors.yellow),

          Teexts().label('4.5', 25.0, Colors.black),
        ],
      )
    );
  }
}


class _Synopsis extends StatelessWidget {

  final String sypnosis;

  const _Synopsis({Key key, this.sypnosis}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10.0),
      padding: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20.0)), 
        color: MyInfo.isDarkMode != true ?
          Colors.white : Colors.black54,
          
        boxShadow: [
          BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
        ]
      ),

      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            
            child: Teexts().label('Sinopsis', 30.0, Colors.black)
          ),

            SizedBox(height: 15.0),

          Align(
            alignment: Alignment.centerLeft,

            child: Teexts().label(
              sypnosis == 'N/A' ?
                'ninguna' : sypnosis,

              20.0, 
              Colors.black
            )
          )
        ]
      ),
    );
  }
}