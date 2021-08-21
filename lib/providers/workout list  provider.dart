import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:workoutnote/models/editible%20lift%20model.dart';
import 'package:workoutnote/models/exercises%20model.dart';
import 'package:workoutnote/models/work%20out%20list%20%20model.dart';
import 'package:workoutnote/providers/create%20workout%20provider.dart';
import 'package:workoutnote/services/network%20%20service.dart';
import 'package:workoutnote/utils/utils.dart';

class MainScreenProvider extends ChangeNotifier {
  //region vars
  List<WorkOut> workOuts = [];
  List<WorkOut> calendarWorkouts = [];
  List<WorkOut> favoriteWorkOuts = [];
  bool requestDone1 = false;
  bool requestDone2 = false;
  bool requestDone3 = false;
  List<String> workOutDates = [];
  DateTime? selectedDate = DateTime.now();

  //endregion
  //region api calls
  Future<bool> fetchTodayWorkouts() async {
    try {
      var sessionKey = userPreferences!.getString("sessionKey") ?? "";
      var fromTimeStamp = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).millisecondsSinceEpoch;
      var tillTimeStamp = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1).millisecondsSinceEpoch - 1;
      var response = await WebServices.fetchWorkOuts(sessionKey, fromTimeStamp, tillTimeStamp);
      if (response.statusCode == 200) {
        var workoutsResponse = WorkOutsResponse.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));

        print("today's lalala:");
        print(jsonDecode(utf8.decode(response.bodyBytes)));
        if (workoutsResponse.success) {
          workOuts.addAll(workoutsResponse.workouts);
          requestDone1 = true;
          for (int i = 0; i < workOuts.length; i++) {
            print(workOuts[i].duration);
          }
          notifyListeners();
          return true;
        }
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> fetchCalendarWorkoutSessions() async {
    if (calendarWorkouts.isNotEmpty) calendarWorkouts.clear();
    try {
      var sessionKey = userPreferences!.getString("sessionKey") ?? "";
      var fromTimestamp = 0;
      var tillTimestamp = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1).millisecondsSinceEpoch - 1;
      var response = await WebServices.fetchWorkOuts(sessionKey, fromTimestamp, tillTimestamp);

      if (response.statusCode == 200) {
        var workoutsResponse = WorkOutsResponse.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
        if (workoutsResponse.success) {
          calendarWorkouts.addAll(workoutsResponse.workouts);
          updateWorkoutDates(calendarWorkouts);
          requestDone3 = true;
        }
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> fetchFavoriteWorkoutSessions(String sessionKey) async {
    try {
      var response = await WebServices.fetchFavoriteWorkoutSessions(sessionKey);
      print(response.body);
      if (response.statusCode == 200 && jsonDecode(response.body)["success"]) {
        var workoutsResponse = WorkOutsResponse.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));

        for (int i = 0; i < workoutsResponse.workouts.length; i++) {
          print("hey ${workoutsResponse.workouts[i].id}");
        }
        favoriteWorkOuts.addAll(workoutsResponse.workouts);
        for (int i = 0; i < favoriteWorkOuts.length; i++) {
          favoriteWorkOuts[i].isFavorite = true;
        }
        requestDone2 = true;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
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

  Future<bool> deleteWorkoutSession(String sessionKey, int id) async {
    try {
      var response = await WebServices.removeWorkout(sessionKey, id);

      if (response.statusCode == 200 && jsonDecode(response.body)["success"]) {
        int timestamp = 0;
        bool isFavorite = false;
        if (requestDone3) {
          timestamp = calendarWorkouts.where((element) => element.id == id).single.timestamp ?? 0;
          isFavorite = calendarWorkouts.where((element) => element.id == id).single.isFavorite;
        } else {
          timestamp = workOuts.where((element) => element.id == id).single.timestamp ?? 0;
          isFavorite = workOuts.where((element) => element.id == id).single.isFavorite;
        }
        workOuts.removeWhere((element) => element.id == id);
        if (isFavorite) favoriteWorkOuts.removeWhere((element) => element.timestamp == timestamp);
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

  //endregion
  //region utils
  void repeatWorkoutSession(int id, CreateWorkoutProvider createWorkoutProvider, List<Exercise> exercises) {
    List<EditableLift> lifts = [];
    String? title;
    for (int i = 0; i < calendarWorkouts.length; i++) {
      if (calendarWorkouts[i].id == id) {
        for (int j = 0; j < calendarWorkouts[i].lifts!.length; j++) {
          title = calendarWorkouts[i].title ?? "[]";
          lifts.add(EditableLift.create(calendarWorkouts[i].lifts![j].exerciseName, calendarWorkouts[i].lifts![j].exerciseId, exercises.isNotEmpty ? exercises.where((element) => element.id == calendarWorkouts[i].lifts![j].exerciseId).first.bodyPart : "", calendarWorkouts[i].lifts![j].liftMas!.toInt(), calendarWorkouts[i].lifts![j].repetitions ?? 0, calendarWorkouts[i].lifts![j].oneRepMax ?? 0.0, true, -1));
        }
      }
    }
    createWorkoutProvider.repeatWorkoutSession(lifts, title ?? "[]");
  }

  void _updateWorkoutFavoriteStatus(int id, int mode) {
    if (mode == 1)
      for (int i = 0; i < workOuts.length; i++) {
        if (workOuts[i].id == id) {
          workOuts[i].isFavorite = !workOuts[i].isFavorite;
          if (calendarWorkouts.isNotEmpty) calendarWorkouts.where((element) => element.id == id).first.isFavorite = workOuts[i].isFavorite;

          if (workOuts[i].isFavorite && requestDone2) {
            print("adding");
            favoriteWorkOuts.add(workOuts[i]);
          } else {
            print("hey1");
            favoriteWorkOuts.removeWhere((element) => element.timestamp == workOuts[i].timestamp);
          }
          break;
        }
      }
    else if (mode == 2)
      for (int i = 0; i < calendarWorkouts.length; i++) {
        if (calendarWorkouts[i].id == id) {
          calendarWorkouts[i].isFavorite = !calendarWorkouts[i].isFavorite;

          if (calendarWorkouts[i].isFavorite && requestDone2) {
            print("adding");
            favoriteWorkOuts.add(calendarWorkouts[i]);
          } else {
            print("hey2");
            favoriteWorkOuts.removeWhere((element) => element.timestamp == calendarWorkouts[i].timestamp);
          }
          for (int j = 0; j < workOuts.length; j++) {
            if (workOuts[j].id == id) {
              workOuts.where((element) => element.id == id).first.isFavorite = calendarWorkouts[i].isFavorite;
              break;
            }
          }
        }
      }

    notifyListeners();
  }

  void reset() {
    print("home screen");
    workOuts.clear();
    calendarWorkouts.clear();
    requestDone1 = false;
    requestDone2 = false;
    requestDone3 = false;
    notifyListeners();
  }

  void updateWorkoutDates(List<WorkOut> workouts) {
    workOutDates.clear();
    for (int i = 0; i < calendarWorkouts.length; i++) {
      workOutDates.add(toDate(calendarWorkouts[i].timestamp ?? 0));
    }
  }

  void update() {
    notifyListeners();
  }
//endregion
}
