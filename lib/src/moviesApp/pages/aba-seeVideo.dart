import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';


class MoviesAppSeeVideo extends StatefulWidget {

  final String videoUrl;

  const MoviesAppSeeVideo({Key key, this.videoUrl}) : super(key: key);

  @override
  _MoviesAppSeeVideoState createState() => _MoviesAppSeeVideoState();
}

class _MoviesAppSeeVideoState extends State<MoviesAppSeeVideo> {

  YoutubePlayerController controller;

  @override
  void initState() {    
    super.initState();

    controller = YoutubePlayerController(
      initialVideoId: widget.videoUrl,
      flags: YoutubePlayerFlags(
        autoPlay: false
      )
    );
  }


  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _checkForLandscape(context),

      child: Scaffold(
        backgroundColor: Colors.black,

        body: SafeArea(
          child: Stack(
            children: [
              Center(
                child: YoutubePlayer(
                  controller: controller,
                  showVideoProgressIndicator: true,

                ),
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios), 
                  color: Colors.amber,
                  iconSize: 40.0,

                  onPressed: () => _checkForLandscape(context).then((value){
                    Navigator.pop(context);
                  })
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _checkForLandscape(BuildContext ctx) async {
    if (MediaQuery.of(ctx).orientation == Orientation.landscape) {
      await SystemChrome.setPreferredOrientations(
        [
          DeviceOrientation.portraitUp,
        ],
      );
      controller.toggleFullScreenMode();
      return false;
    }

    return true;
  }

}