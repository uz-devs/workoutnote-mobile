import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:workoutnote/business_logic/WorkoutListProvider.dart';
import 'package:workoutnote/data/models/UserModel.dart';
import 'package:workoutnote/data/services/Network.dart';
import 'package:workoutnote/utils/Strings.dart';
import 'package:workoutnote/utils/Utils.dart';

class ConfigProvider extends ChangeNotifier {
  //vars
  String? mName, mPassword, mEmail;
  int measureMode = KG;

  //user info
  int c = 0;
  late String g = userPreferences!.getString('gender') ?? 'MALE';
  late String myname;
  String? myemail;
  bool isShared = false;
  late String selectedYear;
  late String selectedMonth;
  late String selectedDay;
  late String sessionKey;
  int val = -1;

  int responseCode = IDLE;

  //api  calls
  Future<bool> sendVerificationCode(String email, name, String password) async {
    mName = name;
    mPassword = password;
    mEmail = email;
    try {
      var response = await WebServices.sendVerification(email);
      if (response.statusCode == 200 && jsonDecode(response.body)['success']) {
        responseCode = SUCCESS;
        return true;
      }
    } on SocketException catch (e) {
      responseCode = SOCKET_EXCEPTION;
      print(e);
    } on Error catch (e) {
      responseCode = MISC_EXCEPTION;
      print(e);
    }

    return false;
  }

  Future<bool> verifyUser(String verificationCode) async {
    try {
      var response = await WebServices.verifyRegister(mName!, mEmail!, verificationCode, mPassword!);
      print(response.body);
      if (response.statusCode == 200 && jsonDecode(response.body)['success']) {
        if (await login(mEmail!, mPassword!)) {
          responseCode = SUCCESS;
          notifyListeners();
          return true;
        }
      }

    }
    on SocketException catch (e) {
      responseCode = SOCKET_EXCEPTION;
      print(e);
    } on Error catch (e) {
      responseCode = MISC_EXCEPTION;
      print(e);
    }
    return false;
  }

  Future<bool> login(String email, String password) async {
    try {
      Response response = await WebServices.userLogin(email, password);
      if (response.statusCode == 200) {
        var user = User.fromJson(jsonDecode(response.body));
        if (user.authSuccess) {
          Response settingsResponse = await WebServices.fetchSettings(user.sessionKey ?? '');
          if (settingsResponse.statusCode == 200) {
            responseCode = SUCCESS;
            print(settingsResponse.body);
            var settings = Settings.fromJson(jsonDecode(settingsResponse.body));
            myemail = email;
            myname = settings.name ?? '';
            selectedYear = settings.dateOfBirth != null ? settings.dateOfBirth!.split('-')[0] : '20000';
            selectedMonth = settings.dateOfBirth != null ? settings.dateOfBirth!.split('-')[1] : '01';
            selectedDay = settings.dateOfBirth != null ? settings.dateOfBirth!.split('-')[2] : '01';
            g = settings.gender!;
            isShared = settings.iProfileShared;


            if (await userPreferences!.setString('sessionKey', user.sessionKey ?? '') && await updatePreferences(email, settings.name ?? '', settings.dateOfBirth ?? '2000-01-01', settings.gender ?? 'MALE', settings.iProfileShared)) return true;
          }
        }

      }
    }   on SocketException catch (e) {
      responseCode = SOCKET_EXCEPTION;
      print(e);
    } on Error catch (e) {
      responseCode = MISC_EXCEPTION;
      print(e);
    }

    return false;
  }

  Future<bool> logout(MainScreenProvider mainScreenProvider) async {
    bool noActiveUser = await userPreferences!.clear();
    mainScreenProvider.reset();

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
        responseCode=SUCCESS;
        return true;
      }
      return false;
    }   on SocketException catch (e) {
      responseCode = SOCKET_EXCEPTION;
      print(e);
    } on Error catch (e) {
      responseCode = MISC_EXCEPTION;
      print(e);
    }
    return false;
  }

  Future<bool> updateProfileSettings(String email, String sessionKey, String name, String gender, String birthDate, bool isProfileShared) async {
    try {
      var response = await WebServices.updateSettings(sessionKey, name, gender, birthDate, isProfileShared);

      if (response.statusCode == 200 && jsonDecode(response.body)['success']) {
        responseCode = SUCCESS;
        updatePreferences(email, name, birthDate, gender, isProfileShared).then((value) {
          if (value) {
            myemail = email;
            myname = name;
            selectedYear = birthDate.split('-')[0];
            selectedMonth = birthDate.split('-')[1];
            selectedDay = birthDate.split('-')[2];
            isShared = isProfileShared;
            g = gender;
            notifyListeners();
            return true;
          }
        });
      }

    }   on SocketException catch (e) {
      responseCode = SOCKET_EXCEPTION;
      print(e);
    } on Error catch (e) {
      responseCode = MISC_EXCEPTION;
      print(e);
    }
    return false;
  }

  //utils
  void setUserInfo() {
    String date = userPreferences!.getString('birthDate') ?? '00-00-00';
    myname = userPreferences!.getString('name') ?? '';
    myemail = userPreferences!.getString('name') ?? '';
    isShared = userPreferences!.getBool('isShared') ?? false;
    g = userPreferences!.getString('gender') ?? 'MALE';
    val = g == 'MALE' ? 1 : 0;
    selectedYear = date.split('-')[0];
    selectedMonth = date.split('-')[1];
    selectedDay = date.split('-')[2];
  }

  Future<bool> updatePreferences(String email, String name, String birthDate, String gender, bool isShared) async {
    if (userPreferences == null) {
      initPreferences().then((value) async {
        return await userPreferences!.setString('email', email) && await userPreferences!.setString('name', name) && await userPreferences!.setString('birthDate', birthDate) && await userPreferences!.setString('gender', gender) && await userPreferences!.setBool('isShared', isShared);
      });
    }
    return await userPreferences!.setString('email', email) && await userPreferences!.setString('name', name) && await userPreferences!.setString('birthDate', birthDate) && await userPreferences!.setString('gender', gender) && await userPreferences!.setBool('isShared', isShared);
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

  String trimField(String value) => trimStringField(value);
}
