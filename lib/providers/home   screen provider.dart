import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:workoutnote/models/work%20out%20list%20%20model.dart';
import 'package:workoutnote/services/network%20%20service.dart';
import 'package:workoutnote/utils/utils.dart';

class MainScreenProvider extends ChangeNotifier {
  //vars
  List<WorkOut> workOuts = [];
  int responseCode1 = 0;
  bool requestDone1 = false;

  //api calls
  Future<void> fetchWorkOuts(String sessionKey, int timestamp) async {
    try {
      var response = await WebServices.fetchWorkOuts(sessionKey, timestamp);
      print(sessionKey);

      if (response.statusCode == 200) {
        var workoutsResponse = WorkOutsResponse.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
        if (workoutsResponse.success) {
          workOuts.addAll(workoutsResponse.workouts);
          responseCode1 = SUCCESS;
          notifyListeners();
        }
      }
    } on TimeoutException catch (e) {
      responseCode1 = TIMEOUT_EXCEPTION;
      print(e);
    } on SocketException catch (e) {
      responseCode1 = SOCKET_EXCEPTION;
      print(e);
    } on Error catch (e) {
      responseCode1 = MISC_EXCEPTION;
      print(e);
    }
  }
  Future<void> setFavoriteWorkOut(String sessionKey, int workoutId) async{
    try {
      var response = await WebServices.setFavoriteWorkOut(sessionKey, workoutId);
      print(response.body);
      if (response.statusCode == 200 && jsonDecode(response.body)["success"]) {
        _updateWorkoutFavoriteStatus(workoutId);
      }

    }
    catch(e){
        print(e);

      }
    }
  Future<void> unsetFavoriteWorkOut(String sessionKey, int workoutId) async{
    try {
      var response = await WebServices.unsetFavoriteWorkOut(sessionKey, workoutId);
      print(response.body);
      if (response.statusCode == 200 && jsonDecode(response.body)["success"]) {
        _updateWorkoutFavoriteStatus(workoutId);
      }
    }
    catch(e){
      print(e);
    }
  }

  //utils
  void _updateWorkoutFavoriteStatus(int id){
    for(int i = 0; i<workOuts.length; i++){
      if(workOuts[i].id == id){
        workOuts[i].isFavorite = !workOuts[i].isFavorite;
        break;
      }
    }
  }

  void reset(){
    workOuts.clear();
    responseCode1 = 0;
    requestDone1 = false;
  }


}
