import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:workoutnote/models/editible%20lift%20model.dart';
import 'package:workoutnote/models/exercises%20model.dart';
import 'package:workoutnote/models/work%20out%20list%20%20model.dart';
import 'package:workoutnote/services/network%20%20service.dart';
import 'package:workoutnote/utils/utils.dart';

class MainScreenProvider extends ChangeNotifier {
  //vars

  List<WorkOut> _workOuts = [];

  int _responseCode1 = 0;
  bool _requestDone1 = false;
  int responseCode2 = 0;
  bool requestDone2 = false;

  //drop down buttons




  Future<void> fetchWorkOuts(String sessionKey, int timestamp) async {
    try {
      var response = await WebServices.fetchWorkOuts(sessionKey, timestamp);
      print(sessionKey);

      if (response.statusCode == 200) {
        var workoutsResponse = WorkOutsResponse.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
        if (workoutsResponse.success) {
          _workOuts.addAll(workoutsResponse.workouts);
          _responseCode1 = SUCCESS;
          notifyListeners();
        }
      }
    } on TimeoutException catch (e) {
      _responseCode1 = TIMEOUT_EXCEPTION;
      print(e);
    } on SocketException catch (e) {
      _responseCode1 = SOCKET_EXCEPTION;
      print(e);
    } on Error catch (e) {
      _responseCode1 = MISC_EXCEPTION;
      print(e);
    }
  }
  Future<void> setFavoriteWorkOut(String sessionKey, int workoutId) async{
    try {
      var response = await WebServices.setFavoriteWorkOut(sessionKey, workoutId);
      print(response.body);
      if (response.statusCode == 200 && jsonDecode(response.body)["success"]) {
        setFavorite(workoutId);
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
        unsetFavorite(workoutId);
      }
    }
    catch(e){
      print(e);
    }
  }
  void unsetFavorite(int id){
    for(int i = 0; i<_workOuts.length; i++){
      if(_workOuts[i].id == id){
        _workOuts[i].isFavorite = !_workOuts[i].isFavorite;
        break;
      }
    }
  }
  void setFavorite(int   id){
    for(int i = 0; i<_workOuts.length; i++){
      if(_workOuts[i].id == id){
        _workOuts[i].isFavorite = !_workOuts[i].isFavorite;
        break;
      }
    }
  }







  List<WorkOut> get workOuts => _workOuts;

  int get responseCode1 => _responseCode1;
  bool get requestDone1 => _requestDone1;



  set requestDone1(bool value) {
    _requestDone1 = value;
  }









}
