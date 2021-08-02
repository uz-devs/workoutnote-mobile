import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:workoutnote/models/exercises%20model.dart';
import 'package:workoutnote/models/work%20out%20list%20%20model.dart';
import 'package:workoutnote/services/network%20%20service.dart';
import 'package:workoutnote/utils/utils.dart';

class MainScreenProvider extends ChangeNotifier {
  List<WorkOut> _workOuts = [];
  List<Exercise> _exercises = [];
  int _responseCode1 = 0;
  bool _requestDone1 = false;
  int _responseCode2 = 0;
  bool _requestDone2 = false;

  List<Map<Exercise, bool>> _selectedExercises = [];
  Exercise? _unselectedExercise;

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

  Future<void> fecthExercises() async {
    try {
      var response = await WebServices.fetchExercises();

      if (response.statusCode == 200) {
        var workoutsResponse = ExercisesResponse.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
        if (workoutsResponse.success) {
          _exercises.addAll(workoutsResponse.exercises ?? []);
          print(_exercises);
          _responseCode2 = SUCCESS;
          notifyListeners();
        }
      }
    } on TimeoutException catch (e) {
      _responseCode2 = TIMEOUT_EXCEPTION;
      print(e);
    } on SocketException catch (e) {
      _responseCode2 = SOCKET_EXCEPTION;
      print(e);
    } on Error catch (e) {
      _responseCode2 = MISC_EXCEPTION;
      print(e);
    }
  }

  List<WorkOut> get workOuts => _workOuts;

  List<Exercise> get exercises => _exercises;

  List<Map<Exercise, bool>> get selectedExercises => _selectedExercises;

  void addExercise(Map<Exercise, bool> exercise) {
    selectedExercises.add(exercise);
    notifyListeners();
  }

  void updateExercise(int index) {
    if (_selectedExercises[index].values.first == false)
      _selectedExercises[index][_selectedExercises[index].keys.first] = true;
    else
      _selectedExercises[index][_selectedExercises[index].keys.first] = false;

    notifyListeners();
  }

  void removeExercises() {
    for(int i = 0; i<_selectedExercises.length; i++){
      if(_selectedExercises[i].values.first)
        _selectedExercises.remove(_selectedExercises[i]);
    }
    notifyListeners();

  }

  Exercise? get unselectedExercise => _unselectedExercise;

  set unselectedExercise(Exercise? value) {
    _unselectedExercise = value;
    notifyListeners();
  }

  int get responseCode1 => _responseCode1;

  bool get requestDone1 => _requestDone1;

  set requestDone1(bool value) {
    _requestDone1 = value;
  }

  bool get requestDone2 => _requestDone2;

  int get reponseCode2 => _responseCode2;

  set requestDone2(bool value) {
    _requestDone2 = value;
  }
}
