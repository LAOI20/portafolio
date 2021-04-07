import 'dart:io';

import 'package:portafolio/src/messagesApp/database/ac-storiesD.dart';

import 'package:portafolio/src/widgets/alertMessage.dart';

import 'package:flutter/material.dart';


class MessageAppAddToMyStories extends StatefulWidget {

  final File imageFile;
  
  MessageAppAddToMyStories({Key key, this.imageFile}) : super(key: key);

  @override
  _MessageAppAddToMyStoriesState createState() => _MessageAppAddToMyStoriesState();
}

class _MessageAppAddToMyStoriesState extends State<MessageAppAddToMyStories> {

  TextEditingController textFieldController = TextEditingController();

  bool showLoaded = false;

  @override
  void dispose() {
    
    textFieldController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) { 
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            //IMAGE CONTAINER
            SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Container(
                height: size.height,
                width: size.width,
                
                child: Image.file(widget.imageFile, fit: BoxFit.fill),
              ),
            ),
            
            //TEXTFIELD FOR ADD COMMENTARY
            Align(
              alignment: Alignment.bottomCenter,

              child: Padding(
                padding: const EdgeInsets.all(12.0),

                child: TextField(
                  controller: textFieldController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blueGrey)
                    ),
                    hintText: 'Escribe un comentario',
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.send, 
                        color: Colors.purple,
                        size: 30.0,
                      ), 
                      onPressed: (){
                        addStory();
                      }
                    )
                  ),
                ),
              )
            ),

            showLoaded == true ?
              loadedWidget(height: size.height, width: size.width)
              :
              SizedBox(height: 0.0)
          ],
        ),
      ),
    );
  }


  Widget loadedWidget({double height,double width}){
    return Container(        
      height: height,
      width: width,
      color: Colors.black.withOpacity(0.7),
      alignment: Alignment.center,
      
      child: Center(
        child: CircularProgressIndicator()
      )
    );
  }

  void addStory(){
    if(textFieldController.text.trim().length > 0){
      setState(() => showLoaded = true);

      FocusScope.of(context).unfocus();
      
      MessageAppStoriesDatabase().addToMyStories(
        widget.imageFile, textFieldController.text

      ).then((value){
        Navigator.pop(context);
      });

    } else {
      AlertMessage().alertaMensaje('Debes agregar un comentario');
    }
  }
  
}