import 'package:get/state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:portafolio/src/services/myInfo.dart';

import 'package:portafolio/src/moviesApp/controllers/a-homeC.dart';

import 'package:portafolio/src/moviesApp/models/a-homeM.dart';

import 'package:portafolio/src/moviesApp/widgets/loadList.dart';
import 'package:portafolio/src/widgets/backgroundImage.dart';
import 'package:portafolio/src/widgets/imagee.dart';
import 'package:portafolio/src/widgets/textfield.dart';

import 'package:flutter/material.dart';

class MoviesAppHome extends StatelessWidget {
  const MoviesAppHome({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MoviesAppHomeController>(
      init: MoviesAppHomeController(),
      builder: (_) {
        return Scaffold(

          body: backgroundImage(

            child: SafeArea(

              child: _.dataLoaded == false ?
                MoviesAppLoadList().moviesLoadList()
                :
                CustomScrollView(
                  physics: BouncingScrollPhysics(),

                  slivers: [
                    //PREMIERES 
                    SliverToBoxAdapter(
                      child: _Premieres(
                        animation: _.moviesAnimation,
                        premieres: _.premieresNames,
                        premieresList: _.premieresList,
                      )
                    ),

                    //MOVIES
                    SliverList(delegate: SliverChildBuilderDelegate(
                      (context, index){
                        return _MovieBody(
                          index: index,
                          movie: _.moviesList[index],
                          onTapCard: () => _.onTapMovieCard(
                            context, index
                          ),
                          animation: _.moviesAnimation,
                        );
                      },

                      childCount: _.moviesList.length

                    ))
                  ],
                ),
            ),
          ),
        );
      }
    );
  }
}


class _Premieres extends StatelessWidget {

  final AnimationController animation;
  final List<String> premieres;
  final List<MovieInfo> premieresList;  

  const _Premieres({Key key, this.animation, this.premieres, this.premieresList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MoviesAppHomeController>();

    return ScaleTransition(
      scale: CurvedAnimation(
        curve: Interval(
          0,
          0.4,
          curve: Curves.bounceOut
        ),
        parent: animation
      ),

      child: Container(
        height: 270.0,

        child: ListView.builder(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: premieres.length,

          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: (){ 
                controller.onTapPremier(
                  premieres[index],
                  premieresList[index],
                  controller.premieresTrailersUrls[premieres[index]]
                );
              },

              child: Container(
                width: 200.0,
                margin: EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 15.0
                ),
                decoration: BoxDecoration(
                  color: Colors.brown,
                  borderRadius: BorderRadius.all(Radius.circular(20.0))
                ),

                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  
                  child: Imagee().squareImage(
                    MoviesAppHomeController()
                      .premieresImagesUrls[premieres[index]][0]
                  ),
                )
              ),
            );
          }
        ),
      ),
    );
  }
}


class _MovieBody extends StatelessWidget {

  final int index;
  final MovieInfo movie;
  final VoidCallback onTapCard;
  final AnimationController animation;

  const _MovieBody({Key key, this.movie, this.animation, this.index, this.onTapCard}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(index + 1.0, 0),
        end: Offset(0, 0)
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Interval(
          0.5,
          1,
          curve: Curves.decelerate
        )
      )),

      child: GestureDetector(
        onTap: onTapCard,

        child: Container(
          width: size.width,
          padding: EdgeInsets.all(8.0),
          margin: EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 12.0
          ),
          decoration: BoxDecoration(
            color: MyInfo.isDarkMode != true ?
              Colors.white : Colors.black54,

            borderRadius: BorderRadius.all(Radius.circular(20.0)), 
            boxShadow: [
              BoxShadow(color: Colors.black.withAlpha(100), blurRadius: 10.0),
            ]
          ),

          child: Row(
            children: [
              Text(
                movie.title,
                style: TextStyle(
                  color: MyInfo.isDarkMode != true ?
                    Colors.black : Colors.white54,
                    
                  fontSize: 22.0,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w700
                ),
              ),

              Spacer(),

              Icon(Icons.star, color: Colors.amber, size: 25.0),

                SizedBox(width: 2.0),

              Teexts().label(movie.rating, 20.0, Colors.black)
            ],
          ),
        ),
      ),
    );
  }
}