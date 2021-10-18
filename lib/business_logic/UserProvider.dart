import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:workoutnote/data/models/UserModel.dart';
import 'package:workoutnote/data/services/Network.dart';
import 'package:workoutnote/utils/Utils.dart';

import 'HomeProvider.dart';

class UserProvider extends ChangeNotifier {
  String? tempName, tempPassword, tempEmail;

  late String userGender = userPreferences!.getString('gender') ?? 'MALE';
  String? userName;
  String? userEmail;
  bool isUserProfileShared = false;
  late String selectedBirthYear, selectedBirthMonth, selectedBirthDay;
  late String sessionKey;
  int responseCode = IDLE;
  int genderGroupValue = -1;

  //api calls
  Future<bool> sendVerificationCode(String email, name, String password) async {
    try {
      var response = await WebServices.sendVerification(email);
      if (!(await checkUsername(email))) {
        if (response.statusCode == 200 && jsonDecode(response.body)['success']) {
          responseCode = SUCCESS;
          tempName = name;
          tempPassword = password;
          tempEmail = email;
          return true;
        }
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

  Future<bool> checkUsername(String email) async {
    try {
      var response = await WebServices.checkUserName(email);

      return jsonDecode(response.body)['isTaken'];
    } catch (e) {
      return false;
    }
  }

  Future<bool> verifyUser(String verificationCode) async {
    try {
      var response = await WebServices.verifyRegister(tempName!, tempEmail!, verificationCode, tempPassword!);
      print(response.body);
      if (response.statusCode == 200 && jsonDecode(response.body)['success']) {
        if (await login(tempEmail!, tempPassword!)) {
          responseCode = SUCCESS;
          notifyListeners();
          return true;
        }
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

  Future<bool> login(String email, String password) async {
    try {
      Response response = await WebServices.userLogin(email, password);
      if (response.statusCode == 200 && jsonDecode(response.body)['success']) {
        var appUser = AppUser.fromJson(jsonDecode(response.body));
        if (appUser.authSuccess) {
          Response settingsResponse = await WebServices.fetchSettings(appUser.sessionKey ?? '');
          if (settingsResponse.statusCode == 200) {
            responseCode = SUCCESS;
            var settings = UserProfile.fromJson(jsonDecode(settingsResponse.body));
            userEmail = email;
            userName = settings.name ?? '';
            selectedBirthYear = settings.dateOfBirth != null ? settings.dateOfBirth!.split('-')[0] : '2000';
            selectedBirthMonth = settings.dateOfBirth != null ? settings.dateOfBirth!.split('-')[1] : '01';
            selectedBirthDay = settings.dateOfBirth != null ? settings.dateOfBirth!.split('-')[2] : '01';
            userGender = settings.gender!;
            isUserProfileShared = settings.iProfileShared;

            if (await userPreferences!.setString('sessionKey', appUser.sessionKey ?? '') && await updatePreferences(email, settings.name ?? '', settings.dateOfBirth ?? '2000-01-01', settings.gender ?? 'MALE', settings.iProfileShared)) return true;
          }
        }
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
        responseCode = SUCCESS;
        return true;
      }
      return false;
    } on SocketException catch (e) {
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
            userEmail = email;
            userName = name;
            selectedBirthYear = birthDate.split('-')[0];
            selectedBirthMonth = birthDate.split('-')[1];
            selectedBirthDay = birthDate.split('-')[2];
            isUserProfileShared = isProfileShared;
            this.userGender = gender;
            notifyListeners();
            return true;
          }
        });
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

  //utils
  void setUserInfo() {
    String date = userPreferences!.getString('birthDate') ?? '00-00-00';
    userName = userPreferences!.getString('name') ?? '';
    userEmail = userPreferences!.getString('email') ?? '';
    isUserProfileShared = userPreferences!.getBool('isShared') ?? false;
    userGender = userPreferences!.getString('gender') ?? 'MALE';
    genderGroupValue = userGender == 'MALE' ? 1 : 0;
    selectedBirthYear = date.split('-')[0];
    selectedBirthMonth = date.split('-')[1];
    selectedBirthDay = date.split('-')[2];
  }

  Future<bool> updatePreferences(String email, String name, String birthDate, String gender, bool isShared) async {
    if (userPreferences == null) {
      initPreferences().then((value) async {
        return await userPreferences!.setString('email', email) && await userPreferences!.setString('name', name) && await userPreferences!.setString('birthDate', birthDate) && await userPreferences!.setString('gender', gender) && await userPreferences!.setBool('isShared', isShared);
      });
    }
    return await userPreferences!.setString('email', email) && await userPreferences!.setString('name', name) && await userPreferences!.setString('birthDate', birthDate) && await userPreferences!.setString('gender', gender) && await userPreferences!.setBool('isShared', isShared);
  }
}
