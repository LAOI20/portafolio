import 'package:portafolio/src/widgets/textfield.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageAppCupertino {

  //USE IN PAGE AC-STORIES || AA-CHAT-SCREEN || AB-SETTINGS
  showCupertinoActions({BuildContext context,
                        VoidCallback onTapTakePhoto,VoidCallback onTapSelectPhoto
                      }){    
    return showCupertinoModalPopup(
      context: context,
      builder: (context){
        return CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              onPressed: onTapTakePhoto,

              child: Teexts().label('Tomar foto', 22.0, Colors.black),
            ),
            CupertinoActionSheetAction(
              onPressed: onTapSelectPhoto,

              child: Teexts().label('Seleccionar foto', 22.0, Colors.black),
            ),
          ],

          cancelButton: CupertinoActionSheetAction(
            onPressed: (){ Navigator.pop(context); },

            child: Text('Cancelar', style: TextStyle(fontSize: 22.0)),
          ),
        );
      }
    );
  }


  showAddFeaturedMessage({BuildContext context,VoidCallback onTapAddMessage}){    
    return showCupertinoModalPopup(
      context: context,
      builder: (context){
        return CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              onPressed: onTapAddMessage,

              child: Teexts().label('Agregar a destacados', 21.0, Colors.black),
            ),
          ],

          cancelButton: CupertinoActionSheetAction(
            onPressed: (){ Navigator.pop(context); },
            
            child: Text('Cancelar', style: TextStyle(fontSize: 21.0)),
          ),
        );
      }
    );
  }

  
}