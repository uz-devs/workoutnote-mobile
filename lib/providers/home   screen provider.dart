import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:workoutnote/models/editible%20lift%20model.dart';
import 'package:workoutnote/models/exercises%20model.dart';
import 'package:workoutnote/models/work%20out%20list%20%20model.dart';
import 'package:workoutnote/providers/create%20workout%20provider.dart';
import 'package:workoutnote/services/network%20%20service.dart';
import 'package:workoutnote/utils/utils.dart';

class MainScreenProvider extends ChangeNotifier {
  //vars
  List<WorkOut> workOuts = [];
  List<WorkOut> calendarWorkouts = [];
  List<WorkOut> favoriteWorkOuts = [];
  int responseCode1 = 0;
  bool  requestDone2 = false;
  bool requestDone1 = false;
  DateTime? selectedDate;

  //api calls
  Future<void> fetchWorkOuts(String sessionKey, int fromTimestamp, int  tillTimeStamp) async {
    try {


      var response = await WebServices.fetchWorkOuts(sessionKey, fromTimestamp, tillTimeStamp);
      print(sessionKey);

      if (response.statusCode == 200) {
        var workoutsResponse = WorkOutsResponse.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
        if (workoutsResponse.success) {
          workOuts.addAll(workoutsResponse.workouts);
          print("durations");
          for (int i = 0; i < workOuts.length; i++) {
            print(workOuts[i].duration);
          }
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

  Future<void> fetchWorkOutsByDate(String sessionKey, int fromTimestamp, int tillTimestamp) async {
    if (calendarWorkouts.isNotEmpty) calendarWorkouts.clear();
    try {
      var response = await WebServices.fetchWorkOuts(sessionKey, fromTimestamp, tillTimestamp);
      print(sessionKey);

      if (response.statusCode == 200) {
        var workoutsResponse = WorkOutsResponse.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
        if (workoutsResponse.success) {
          calendarWorkouts.addAll(workoutsResponse.workouts);
          notifyListeners();
        }
      }
    } on TimeoutException catch (e) {
      print(e);
    } on SocketException catch (e) {
      print(e);
    } on Error catch (e) {
      print(e);
    }
  }

  Future<bool> fetchFavoriteWorkoutSessions(String sessionKey) async {
    try {
      var response = await WebServices.fetchFavoriteWorkoutSessions(sessionKey);
      print("workouts");
      print(response.body);
      if (response.statusCode == 200 && jsonDecode(response.body)["success"]) {
        var workoutsResponse = WorkOutsResponse.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
        favoriteWorkOuts.addAll(workoutsResponse.workouts);
        requestDone2 = true;
        notifyListeners();
        return true;
      }
      return false;
    }

    catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> setFavoriteWorkOut(String sessionKey, int workoutId, int mode) async {
    try {
      var response = await WebServices.setFavoriteWorkOut(sessionKey, workoutId);
      print(response.body);
      if (response.statusCode == 200 && jsonDecode(response.body)["success"]) {
        _updateWorkoutFavoriteStatus(workoutId, mode);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> unsetFavoriteWorkOut(String sessionKey, int workoutId, int mode) async {
    try {
      var response = await WebServices.unsetFavoriteWorkOut(sessionKey, workoutId);
      print(response.body);
      if (response.statusCode == 200 && jsonDecode(response.body)["success"]) {
        _updateWorkoutFavoriteStatus(workoutId, mode);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> updateWorkoutSession(String sessionKey, int id, String newTitle, int newDuration) async {
    try {
      var response = await WebServices.updateWorkout(sessionKey, id, newTitle, newDuration);
      if (response.statusCode == 200 && jsonDecode(response.body)["success"]) {
        var workout = workOuts
            .where((element) => element.id == id)
            .single;
        var calendarWorkout = calendarWorkouts
            .where((element) => element.id == id)
            .single;
        workout.title = newTitle;
        workout.duration = newDuration;
        calendarWorkout.title = newTitle;
        calendarWorkout.duration = newDuration;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> deleteWorkoutSession(String sessionKey, int id) async {
    try {
      var response = await WebServices.removeWorkout(sessionKey, id);
      print(response.body);
      if (response.statusCode == 200 && jsonDecode(response.body)["success"]) {
        workOuts.removeWhere((element) => element.id == id);
        calendarWorkouts.removeWhere((element) => element.id == id);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  //utils

  void repeatExercise(int id, CreateWorkoutProvider createWorkoutProvider, List<Exercise> exercises) {
    List<EditableLift> lifts = [];
    String? title;
    for (int i = 0; i < workOuts.length; i++) {
      if (workOuts[i].id == id) {
        for (int j = 0; j < workOuts[i].lifts!.length; j++) {
          title = workOuts[i].title ?? "[]";
          lifts.add(EditableLift.create(
              workOuts[i].lifts![j].exerciseName,
              workOuts[i].lifts![j].exerciseId,
              exercises.isNotEmpty ? exercises
                  .where((element) => element.id == workOuts[i].lifts![j].exerciseId)
                  .first
                  .bodyPart : "",
              workOuts[i].lifts![j].liftMas!.toInt(),
              workOuts[i].lifts![j].repetitions ?? 0,
              1.2,
              true));
        }
      }
    }
    createWorkoutProvider.repeatExercise(lifts, title ?? "[]");
  }

  void _updateWorkoutFavoriteStatus(int id, int mode) {
    if (mode == 1)
      for (int i = 0; i < workOuts.length; i++) {
        if (workOuts[i].id == id) {
          workOuts[i].isFavorite = !workOuts[i].isFavorite;
          calendarWorkouts
              .where((element) => element.id == id)
              .first
              .isFavorite = workOuts[i].isFavorite;
          break;
        }
      }
    else
      for (int i = 0; i < calendarWorkouts.length; i++) {
        if (calendarWorkouts[i].id == id) {
          calendarWorkouts[i].isFavorite = !calendarWorkouts[i].isFavorite;
          workOuts
              .where((element) => element.id == id)
              .first
              .isFavorite = calendarWorkouts[i].isFavorite;

          break;
        }
      }
  }

  void reset() {
    workOuts.clear();
    calendarWorkouts.clear();
    responseCode1 = 0;
    requestDone1 = false;
  }
}
