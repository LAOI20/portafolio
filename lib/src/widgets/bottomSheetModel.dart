import 'package:flutter/material.dart';

class BottomSheetModel {

  bottomSheet({BuildContext context,Widget Function(BuildContext, ScrollController) builder}){
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context, 
      builder: (context){
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.85,
          minChildSize: 0.65,
          maxChildSize: 0.85,

          builder: builder
        );
      }
    );
  }

  Widget columnAndTitle({String title,Widget child}){
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 6.0),

          child: Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontSize: 22.0,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w700
            ),
          )
        ),

        Expanded(
          child: child,
        )
      ],
    );
  }

}