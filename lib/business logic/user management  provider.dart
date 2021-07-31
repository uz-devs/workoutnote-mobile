import 'dart:convert';

import 'package:flutter/foundation.dart';
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
       print(response);
      if (response.statusCode == 200) {

        var user = User.fromJson(jsonDecode(response.body));
        print(user.authSuccess);
        print(user.sessionKey);

        if (user.authSuccess) {
          userPreferences!.setString("sessionKey", user.sessionKey ?? "");
          return true;
        }
      }
    } catch (e) {
      print(e);
      return false;
    }
    return false;
  }
}
