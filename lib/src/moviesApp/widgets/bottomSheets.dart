import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/state_manager.dart';

import 'package:portafolio/src/moviesApp/controllers/a-homeC.dart';

import 'package:portafolio/src/moviesApp/models/a-homeM.dart';

import 'package:portafolio/src/widgets/bottomSheetModel.dart';
import 'package:portafolio/src/widgets/loadings.dart';
import 'package:portafolio/src/widgets/textfield.dart';

import 'package:flutter/material.dart';



class MoviesAppBottomSheets {


  showMovieImages(BuildContext context,int movieIndx,MovieInfo movie){
    BottomSheetModel().bottomSheet(
      context: context,
      builder: (context, scrollController){
        return BottomSheetModel().columnAndTitle(
          title: movie.title,
          
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),

            child: GetBuilder<MoviesAppHomeController>(
              id: 'bottomSheetContainer',
              builder: (_) {
                List imagesUrls = _.moviesImagesUrls[movieIndx]['imagesUrls'];

                return imagesUrls.length == 0 ?
                  Loadings().loadWidgetInBottomSheet()
                  :
                  SingleChildScrollView(
                    controller: scrollController,

                    child: DefaultTabController(
                      length: 2, 

                      child: Column(
                        children: [
                          TabBar(
                            onTap: (index){
                              _.onTapBottomSheetTabBar(index);
                            },

                            indicatorColor: Colors.grey[300],
                            labelColor: Colors.black,
                            
                            tabs: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                
                                child: Teexts().label(
                                  'Imagenes', 
                                  _.tabBarSelect == 0 ? 20.0 : 16.0,
                                  _.tabBarSelect == 0 ?
                                    Colors.black
                                    :
                                    Colors.grey
                                )
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                
                                child: Teexts().label(
                                  'Info', 
                                  _.tabBarSelect == 1 ? 20.0 : 16.0,                                  
                                  _.tabBarSelect == 1 ?
                                    Colors.black
                                    :
                                    Colors.grey
                                )
                              ),
                            ]
                          ),

                            SizedBox(height: 10.0),

                          _.tabBarSelect == 0 ?
                            _GridViewList(
                              movieIndx: movieIndx,
                              imagesUrls: imagesUrls,
                            )
                            :
                            _PageMovieInfo(
                              movie: movie
                            )
                        ],
                      ),
                    ),
                  );
              }
            ),
          )
        );        
      }
    );        
  }

}


class _GridViewList extends StatelessWidget {

  final int movieIndx;
  final List imagesUrls;

  const _GridViewList({Key key, this.movieIndx, this.imagesUrls}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StaggeredGridView.countBuilder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisCount: movieIndx.isEven ? 2 : 3,
      itemCount: imagesUrls.length,

      itemBuilder: (context, index){
        return ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          
          child: FadeInImage(
            fit: BoxFit.cover,
            fadeInDuration: Duration(milliseconds: 500),
            placeholder: AssetImage('images/loading.gif'),
            image: NetworkImage(imagesUrls[index]),
          ),
        );
      },
      staggeredTileBuilder: (index) => movieIndx.isEven ?
        StaggeredTile.fit(1)
        :
        StaggeredTile.count(
          (index % 7 == 0) ? 2 : 1,
          (index % 7 == 0) ? 2 : 1
        ),

      mainAxisSpacing: 5.0,
      crossAxisSpacing: 5.0,
    );
  }
}

class _PageMovieInfo extends StatelessWidget {

  final MovieInfo movie;

  const _PageMovieInfo({Key key, this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //RANTING
        Container(
          padding: EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.amber, width: 4.0),
            borderRadius: BorderRadius.all(Radius.circular(20.0))
          ),

          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.star, color: Colors.amber, size: 25.0),
                
                SizedBox(width: 3.0),

              Teexts().label(movie.rating, 20.0, Colors.black),
            ],
          ),
        ), 

          SizedBox(height: 10.0),

        //YEAR  RUNTIME  GENRE  DIRECTOR  ACTORS
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 4.0),
            borderRadius: BorderRadius.all(Radius.circular(20.0))
          ),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerRight,

                child: Teexts().label('Año : ${movie.year}', 19.0, Colors.black)
              ),

              Teexts().label('Duracion : ${movie.runTime}', 19.0, Colors.black),

              Divider(thickness: 2.0),

              Teexts().label('Genero : ${movie.genre}', 19.0, Colors.black),
              
              Divider(thickness: 2.0),

              Teexts().label('Director : ${movie.director}', 19.0, Colors.black),

              Divider(thickness: 2.0),

              Teexts().label('Actores : ${movie.actors}', 19.0, Colors.black),
            ],
          ),
        ),

          SizedBox(height: 10.0),

        //PLOT
        Container(
          padding: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 4.0),
            borderRadius: BorderRadius.all(Radius.circular(20.0))
          ),

          child: Teexts().label(movie.plot, 19.0, Colors.black)
        ),

          SizedBox(height: 10.0),
      ],
    );
  }
}