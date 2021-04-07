import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import 'package:portafolio/src/moviesApp/models/a-homeM.dart';

import 'dart:convert';

class APImodel {
  
  Future<http.Response> postHttp(
    String path, 
    {dynamic body,
     dynamic headers
    }
  ) async{

    http.Response response;

    try {
      
      response = await http.post(
        Uri.parse(path),
        headers: headers,
        body: body
      );

    } catch (e) {
      print('ERRROOORRR HTTP $e');
    }

    return response;
  }

  Future<http.Response> getHttp(
    String path,
    {Map<String, dynamic> headers}
  ) async{

    http.Response response;

    try {
      
      response = await http.get(
        Uri.parse(path),
        headers: headers
      );

    } catch (e) {
      print('ERRROOORRR HTTP $e');
    }

    return response;
  }


  /*Future<Response> reequest(
    String path, 
    {String method, Map<String, dynamic> queryParameters,
     Map<String, dynamic> data,
     Map<String, dynamic> headers,
    }) async {

      Response response;

      try {
        
        response = await dio.request(
          path,
          options: Options(
            method: method,
            headers: headers,
          ),
          queryParameters: queryParameters,
          data: data
        );

      } catch (e) {

        if(e is DioError){
          if(e.response != null){
            print(e.response.data['message']);
            response = e.response;
          }
        }

        print(e);

      }
      
      return Future.value(response);
    }*/




// ECOMMERCE APP
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  Future<List<dynamic>> getDataShipment({String postalCode,String shipmentName}) async{

    List<dynamic> response = [];   

    final bodyParse =
      json.encode({
        "api_key":"c9b4ed1385c8ea3c87933fc61249ce25",
          "shipment": {
            "shipment_type":"Package",
            "parcels":
              {
                "quantity":"1",
                "weight":"2",
                "weight_unit":"kg",
                "height":"10",
                "length":"10",
                "width":"10",
                "dimension_unit":"cm"
              }
          
          },
          "origin_direction": {
            "country_code":"MX",
            "postal_code":"46400"
          },
          "destination_direction": {
            "country_code":"MX",
            "postal_code": postalCode
          },
          "intelligent_filtering": true
      });
    
    
    await http.post(
      Uri.parse('https://enviaya.com.mx/api/v1/rates'),
      headers: {'Content-Type': 'application/json'},
      body: bodyParse

    ).then((res){    
      final Map parsedResponse = json.decode(res.body);

      if(res.statusCode == 201){
        String resultDate;    
    
        DateTime now = DateTime.now();
        DateTime startYear = DateTime(now.year, 1,1);
      
        DateTime deliveryDate = DateTime.parse(
          parsedResponse[shipmentName][0]['estimated_delivery']
        );
      
        int todayDay = now.difference(startYear).inDays;
        int deliveryDay = deliveryDate.difference(startYear).inDays;

        if(todayDay == deliveryDay){
          resultDate = 'hoy';
        } else if(todayDay + 1 == deliveryDay){
          resultDate = 'mañana';
        } else if(todayDay + 2 == deliveryDay){
          resultDate = DateFormat('EEEE', 'es_MX').format(deliveryDate);
        } else if(todayDay + 3 == deliveryDay){
          resultDate = DateFormat('EEEE', 'es_MX').format(deliveryDate);
        } else if(todayDay + 4 == deliveryDay){
          resultDate = DateFormat('EEEE', 'es_MX').format(deliveryDate);
        } else if(todayDay + 5 == deliveryDay){
          resultDate = DateFormat('EEEE', 'es_MX').format(deliveryDate);
        } else {
          resultDate = DateFormat.yMd('es').format(deliveryDate);
        }

        response.add(resultDate);
        response.add(parsedResponse[shipmentName][0]['list_total_amount']);
      }
    });

    await getHttp(
      'https://api-sepomex.hckdrk.mx/query/info_cp/$postalCode?token=c774a7b3-a87e-439a-8b00-9ee6f4d29cf9',

    ).then((res){
      List listResult = json.decode(res.body);
     
      String jsonResponse = json.encode(listResult[0]);
      final Map parsedResponse = json.decode(utf8.decode(jsonResponse.codeUnits));

      String city = parsedResponse['response']['ciudad'];
      String state = parsedResponse['response']['estado'];
      String join = '$city, $state';

      response.add(join); 
    });
    
    return response;
  }
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<




// MOVIES APP
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  Future<List<MovieInfo>> getMoviesData(List<String> movies) async{

    List<MovieInfo> resultList = [];        
    
    await Future.forEach(movies, (String name) async{

      await getHttp(
        'http://www.omdbapi.com/?t=$name&apikey=cb5082f7',

      ).then((res){
        final Map pasedResponse = json.decode(res.body);

        if(pasedResponse['Response'] == 'True'){

          resultList.add(MovieInfo.fromData(
            pasedResponse['Title'], pasedResponse['Year'], pasedResponse['Runtime'], 
            pasedResponse['Genre'], pasedResponse['Director'], pasedResponse['Actors'], 
            pasedResponse['Plot'], pasedResponse['imdbRating']
          ));
        }

      });

    });

    return resultList;

  }
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<



//PUSH NOTIFICATIONS MODEL
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  notificationsAPI({String to,String title,String sound,
                    String body, 
                    Map<String,dynamic> data
  }){
    postHttp(
      'https://fcm.googleapis.com/fcm/send',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'key=AAAAL-Jx_9A:APA91bHwRFlzTzdUFxtdS_JZtujf3N4IFNwyuqySnEEXAe_0Q1qRj_BP4Uvu4yupOp1-S4nuB6qderGak_Lt9ztkGo9MSO6Py0lpfkCf4FZ2eSU3YWiBNc0SFBoWZrSJlf2vxOaxljbf'
      },
      body: json.encode({
          "to": to,
          "notification": {
              "title": title,
              "body": body,
              "sound": 'default'
          },
          "data": data
      })
    );
  }

  notificationVideoCallAPI({String to, Map<String,dynamic> data}){
    postHttp(
      'https://fcm.googleapis.com/fcm/send',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'key=AAAAL-Jx_9A:APA91bHwRFlzTzdUFxtdS_JZtujf3N4IFNwyuqySnEEXAe_0Q1qRj_BP4Uvu4yupOp1-S4nuB6qderGak_Lt9ztkGo9MSO6Py0lpfkCf4FZ2eSU3YWiBNc0SFBoWZrSJlf2vxOaxljbf'
      },
      body: json.encode({
        "to": to,
        "priority":"high",
        "data": data
      })
    );
  }
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

}