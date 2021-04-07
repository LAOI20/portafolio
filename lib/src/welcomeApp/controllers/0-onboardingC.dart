import 'package:get/state_manager.dart';

import 'package:portafolio/src/welcomeApp/widgets/onboardingWidget.dart';

import 'package:flutter/material.dart';


class WelcomeAppOnboardingController extends GetxController {

  BuildContext context;

  var selectPageIndex = 0.obs;  

  List<Widget> pages = [
    WelcomeAppOnboardingWidget().pagesBody(
      animatedTitles: ["Gestion", "Estado", "GetX"],
      description: 'En esta app utilice getx\npara la gestion de estado\nporque me gusta probar cosas nuevas',
      color: Colors.amber
    ),
    WelcomeAppOnboardingWidget().pagesBody(
      animatedTitles: ["Gesto", "Desplazamiento", "atras"],
      description: 'en la mayoria de pantallas\nno hay icono de retroceso\npara retroceder debes hacer un gesto como en ios de izquierda a derecha\nesto lo hice asi porque aumenta la usabilidad de la app',
      color: Colors.indigo
    ),
    WelcomeAppOnboardingWidget().pagesBody(
      animatedTitles: ["Apps", "Que", "Contiene"],
      description: 'Mensajeria\nApp donde puedes chatear, enviar fotos y compartir historias con tus amigos\n  \nEcommerce\napp para comprar productos en linea y acepta pagos con tarjeta\n  \nPeliculas\napp para ver una cartelera de peliculas y estrenos',
      color: Colors.pink
    ),
  ];
  

  void onChangedPage(int value){
    selectPageIndex.value = value;
    update();
  }

}