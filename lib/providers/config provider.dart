import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:workoutnote/models/user%20model.dart';
import 'package:workoutnote/services/network%20%20service.dart';
import 'package:workoutnote/utils/strings.dart';
import 'package:workoutnote/utils/utils.dart';

class ConfigProvider extends ChangeNotifier {


  //vars
  String? n, p,  e;

  //api  calls
  Future<bool> sendVerificationCode(String email, name, String password) async {

    n = name;
    p = password;
    e = email;

    try{
      var  response = await WebServices.sendVerification(email);
      if(response.statusCode == 200 &&  jsonDecode(response.body)["success"]){
        return  true;
      }
    }
    catch(e){
      print(e);
      return  false;
    }
    return  false;
  }
  Future<bool> verifyUser(String verificationCode) async {
    try{
      var  response =await  WebServices.verifyRegister(n!, e!, verificationCode, p!);
      print(response.body);
      if(response.statusCode == 200 && jsonDecode(response.body)["success"]){
         if(await login(e!, p!)){
           return  true;
         }
      }
      return false;
    }
    catch(e){
      print(e);
      return  false;
    }
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
    bool noActiveUser =  await userPreferences!.clear();
    if(noActiveUser){
      notifyListeners();
      return true;
    }
     return false;
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



  //utils
  Future<void> changeLanguage(int  val) async{
    switch(val){
      case 1: {
        await userPreferences!.setString("language", lList[0].name??korean);
        break;
      }
      case 2:{
        await  userPreferences!.setString("language", lList[1].name??korean);
        break;
      }

    }
    notifyListeners();
  }
  int  value() {
    switch(userPreferences!.getString("language")){
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
    return  userPreferences!.getString("language")??korean;
  }
}
