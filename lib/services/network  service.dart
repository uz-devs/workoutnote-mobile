import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:workoutnote/utils/utils.dart';

class WebServices {
  static Map<String, String> headers = {'Accept': 'application/json; charset=UTF-8'};
  static Future<http.Response> userLogin(String email, String password) async {
    final url = Uri.https(baseUrl, login);
    final body = {'email': '$email', 'password': '$password'};
    http.Response response = await http.post(url, headers: headers, body: jsonEncode(body));
    return response;
  }
  static Future<http.Response> fetchWorkOuts(String sessionKey, int timestamp) async {
    final url = Uri.https(baseUrl,  workouts);
    final body = {'sessionKey': '$sessionKey', 'dateTimestampMs': '$timestamp'};
    http.Response response = await http.post(url, headers: headers, body: jsonEncode(body));
    return response;
  }

  static Future<http.Response> fetchExercises() async {
    final url = Uri.https(baseUrl,exerc );
    final body = {};
    http.Response response = await http.post(url, headers: headers, body: jsonEncode(body));
    return response;
  }

}
