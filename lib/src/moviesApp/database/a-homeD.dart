import 'package:firebase_storage/firebase_storage.dart';


class MoviesAppHomeDatabase {

  FirebaseStorage _storage = FirebaseStorage.instance;


  Future<List<String>> getMovieImagesUrls(String movieName) async{

    List<String> result = [];

    await _storage
      .ref().child(movieName).listAll()
      .then((valueList) async{
                
        await Future.forEach(valueList.items, (Reference element) async{          
          String url = await element.getDownloadURL();

          result.add(url);
        });

      });
    
    return result;
  }

}