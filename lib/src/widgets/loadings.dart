import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Loadings {
  
  
  Widget circularLoaded(){
    return Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: AssetImage('images/loading.gif'),
            fit: BoxFit.cover
          )
        ),
      ),
    );
  }

  Widget loadWidgetFullScreen(BuildContext context){
    return Container(        
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: Colors.black.withOpacity(0.7),
      alignment: Alignment.center,
      
      child: Center(
        child: SpinKitCubeGrid(
          color: Colors.grey,
          size: 100.0,
        )
      )
    );
  }

  Widget loadWidgetInBottomSheet(){
    return Center(
      child: SpinKitCubeGrid(
        color: Colors.grey,
        size: 100.0,
      ),
    );
  }

}