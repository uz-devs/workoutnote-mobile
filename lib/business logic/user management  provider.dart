import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:workoutnote/models/user%20model.dart';
import 'package:workoutnote/services/network%20%20service.dart';
import 'package:workoutnote/utils/utils.dart';

class UserManagement extends ChangeNotifier {



  bool signup() {
    return true;
  }
  Future<bool> login(String email, String password) async {
    try {
      Response response = await WebServices.userLogin(email, password);
      if (response.statusCode == 200) {
        var user = User.fromJson(jsonDecode(response.body));
        if (user.authSuccess) {
          Response settingsResponse = await WebServices.fetchSettings(user.sessionKey??"");
          if(settingsResponse.statusCode == 200){

            var  settings = Settings.fromJson(jsonDecode(settingsResponse.body));
            await userPreferences!.setString("email", email);
            await userPreferences!.setString("name", settings.name??"unknown");
            await userPreferences!.setString("birthDate", settings.dateOfBirth??"unknown");
            await userPreferences!.setString("gender", settings.gender??"unknown");
            await userPreferences!.setBool("isShared", settings.iProfileShared);
            await userPreferences!.setString("sessionKey", user.sessionKey ?? "");
            return true;
          }

        }
      }
    } catch (e) {
      print(e);
      return false;
    }
    return false;
  }
  Future<bool> logout()async{
    return await userPreferences!.clear();
  }
  Future<bool> updateProfileSettings(String sessionKey, String name, String gender) async {

    try{
      var response = await  WebServices.updateSettings(sessionKey, name,  gender);
      if(response.statusCode == 200 && jsonDecode(response.body)["success"]){
        userPreferences!.setString("name", name);
        userPreferences!.setString("gender", gender);
        notifyListeners();
        return true;
      }
      return false;
    }
    catch(e){
      print(e);
      return false;
    }


  }




}
