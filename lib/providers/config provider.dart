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
  String? mName, mPassword, mEmail;
  int measureMode = KG;

  //user info
  late String g = userPreferences!.getString('gender') ?? 'MALE';
  late String myname;
  late String myemail;
  bool isShared = false;
  late String selectedYear;
  late String selectedMonth;
  late String selectedDay;
  int val = -1;

  //api  calls
  Future<bool> sendVerificationCode(String email, name, String password) async {
    mName = name;
    mPassword = password;
    mEmail = email;
    try {
      var response = await WebServices.sendVerification(email);
      print(response.body);
      if (response.statusCode == 200 && jsonDecode(response.body)['success']) {
        return true;
      }
    } catch (e) {
      print(e);
      return false;
    }
    return false;
  }

  Future<bool> verifyUser(String verificationCode) async {
    try {
      var response = await WebServices.verifyRegister(mName!, mEmail!, verificationCode, mPassword!);
      print(response.body);
      if (response.statusCode == 200 && jsonDecode(response.body)['success']) {
        if (await login(mEmail!, mPassword!)) {
          return true;
        }
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      Response response = await WebServices.userLogin(email, password);
      print(response.body);
      if (response.statusCode == 200) {
        var user = User.fromJson(jsonDecode(response.body));
        if (user.authSuccess) {
          Response settingsResponse = await WebServices.fetchSettings(user.sessionKey ?? '');
          if (settingsResponse.statusCode == 200) {
            print(settingsResponse.body);
            var settings = Settings.fromJson(jsonDecode(settingsResponse.body));
            updatePreferences(email, settings.name ?? '', settings.dateOfBirth ?? '2000-01-01', settings.gender ?? 'MALE', settings.iProfileShared).then((value) {
              myemail = email;
              myname = settings.name!;
              selectedYear = settings.dateOfBirth !=null?settings.dateOfBirth!.split('-')[0]:'20000';
              selectedMonth =settings.dateOfBirth !=null? settings.dateOfBirth!.split('-')[1]:'01';
              selectedDay = settings.dateOfBirth !=null?settings.dateOfBirth!.split('-')[2]:'01';
              g = settings.gender!;

              isShared = settings.iProfileShared;
            });
            await userPreferences!.setString('sessionKey', user.sessionKey ?? '');
            return true;
          }
        }
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
    return false;
  }

  Future<bool> logout() async {
    bool noActiveUser = await userPreferences!.clear();
    if (noActiveUser) {
      notifyListeners();
      return true;
    }
    return false;
  }

  Future<bool> passwordReset(String email) async {
    try {
      var response = await WebServices.resetPassword(email);

      print(response.body);
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> updateProfileSettings(String email, String sessionKey, String name, String gender, String birthDate, bool isProfileShared) async {
    print(gender);
    try {
      var response = await WebServices.updateSettings(sessionKey, name, gender, birthDate, isProfileShared);

      print(response.body);
      if (response.statusCode == 200 && jsonDecode(response.body)['success']) {
        updatePreferences(email, name, birthDate, gender, isProfileShared).then((value) {
          myemail = email;
          myname = name;
          selectedYear = birthDate.split('-')[0];
          selectedMonth = birthDate.split('-')[1];
          selectedDay = birthDate.split('-')[2];
          isShared = isProfileShared;
          g = gender;
          notifyListeners();
          return true;
        });
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  //utils
  void setUserInfo() {
    String date = userPreferences!.getString('birthDate') ?? '00-00-00';
    myname = userPreferences!.getString('name') ?? '';
    myemail = userPreferences!.getString('name') ?? '';
    isShared = userPreferences!.getBool('isShared') ?? false;
    g = userPreferences!.getString('gender')??'MALE';
    val = g=='MALE'?1:0;
    selectedYear = date.split('-')[0];
    selectedMonth = date.split('-')[1];
    selectedDay = date.split('-')[2];
  }

  Future<void> updatePreferences(String email, String name, String birthDate, String gender, bool isShared) async {
    await userPreferences!.setString('email', email);
    await userPreferences!.setString('name', name);
    await userPreferences!.setString('birthDate', birthDate);
    await userPreferences!.setString('gender', gender);
    await userPreferences!.setBool('isShared', isShared);
  }

  Future<void> changeLanguage(int val) async {
    switch (val) {
      case 1:
        {
          await userPreferences!.setString('language', lList[0].name ?? korean);
          break;
        }
      case 2:
        {
          await userPreferences!.setString('language', lList[1].name ?? korean);
          break;
        }
    }
    notifyListeners();
  }

  void changeMassMeasurement() {
    if (measureMode == KG) {
      measureMode = LBS;
    } else {
      measureMode = KG;
    }
    notifyListeners();
  }

  double getConvertedMass(double mass) {
    if (measureMode == KG) {
      return mass;
    } else {
      return roundDouble((2.2 * mass), 2);
    }
  }

  double getConvertedRM(double rm) {
    if (measureMode == KG) {
      return roundDouble(rm, 2);
    } else
      return roundDouble(2.2 * rm, 2);
  }

  int languageCode() {
    switch (userPreferences!.getString('language')) {
      case english:
        {
          return 1;
        }
      case korean:
        {
          return 2;
        }

      default:
        {
          return 1;
        }
    }
  }

  String? activeLanguage() {
    return userPreferences!.getString('language') ?? korean;
  }
}
