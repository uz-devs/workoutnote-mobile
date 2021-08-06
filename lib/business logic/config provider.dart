


import 'package:flutter/foundation.dart';
import 'package:workoutnote/utils/strings.dart';
import 'package:workoutnote/utils/utils.dart';

class ConfigProvider extends ChangeNotifier{

  Future<void> changeLanguage(int  val, List<Language> lList) async{
    switch(val){
      case 1: {
        await languagePreferences!.setString("language", lList[0].name??english);
        break;
      }
      case 2:{
      await  languagePreferences!.setString("language", lList[1].name??english);
        break;
      }

    }

    notifyListeners();
  }

  int  value() {
    switch(languagePreferences!.getString("language")){
      case english: {
        return 1;
      }
      case korean :{
        return 2;

      }

      default: {
       return 1;
      }
    }
  }
  String? activeLanguage () {
    return  languagePreferences!.getString("language")??english;
  }
}