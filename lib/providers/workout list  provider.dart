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
  List<Map<String , String>> notes = [];
  bool requestDone1 = false;
  bool requestDone2 = false;
  bool requestDone3 = false;
  List<String> workOutDates = [];
  DateTime? selectedDate = DateTime.now();
  var currentMonthIndex = DateTime.now().month - 1;
  var noteController = TextEditingController();

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

        if (workoutsResponse.success) {
          workOuts.addAll(workoutsResponse.workouts);
          requestDone1 = true;

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

      if (response.statusCode == 200 && jsonDecode(response.body)["success"]) {
        var workoutsResponse = WorkOutsResponse.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));

        for (int i = 0; i < workoutsResponse.workouts.length; i++) {}
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

      if (response.statusCode == 200 && jsonDecode(response.body)["success"]) {
        _updateWorkoutFavoriteStatus(workoutId, mode);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> deleteWorkoutSession(String sessionKey, int id) async {
    print("start");
    try {
      var response = await WebServices.removeWorkout(sessionKey, id);

      if (response.statusCode == 200 && jsonDecode(response.body)["success"]) {
        int timestamp = 0;
        bool isFavorite = false;
        print("1");
        if (requestDone3) {
          print("2");

          timestamp = calendarWorkouts.where((element) => element.id == id).single.timestamp ?? 0;
          isFavorite = calendarWorkouts.where((element) => element.id == id).single.isFavorite;
        } else {
          print("3");

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

  Future<String> fetchSingleNote( int timestamp) async {


    print("fetching single note");
    print("timestamp: ${timestamp}");


    var sessionKey = userPreferences!.getString("sessionKey") ?? "";

    try {

      var response = await WebServices.fetchCalendarNote(sessionKey, timestamp);

      print(response.statusCode);
      if(response.statusCode == 200){

        print(response.body);
        String currentNote = jsonDecode(utf8.decode(response.bodyBytes))["note"];
        notes.add({toDate(timestamp): jsonDecode(utf8.decode(response.bodyBytes))["note"]});

        return  currentNote;
      }
      return  "";
    }
    catch(e){
      print(e);
      return  "";

    }
  }

  Future<bool> saveNote( int timestamp, String note) async {

    print("timestamp: ${timestamp}");
    var sessionKey = userPreferences!.getString("sessionKey") ?? "";

    try {
      var response = await WebServices.saveCalendarNote(sessionKey, timestamp, note);
      print(response.body);
      if (response.statusCode == 200) {
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
  Future<void> repeatWorkoutSession(int id, CreateWorkoutProvider createWorkoutProvider, List<Exercise> exercises, int mode) async {
    List<EditableLift> lifts = [];
    String? title;

    if (calendarWorkouts.isNotEmpty) {
      for (int i = 0; i < calendarWorkouts.length; i++) {
        if (calendarWorkouts[i].id == id) {
          for (int j = 0; j < calendarWorkouts[i].lifts!.length; j++) {
            title = calendarWorkouts[i].title ?? "";
            lifts.add(EditableLift.create(calendarWorkouts[i].lifts![j].exerciseName, calendarWorkouts[i].lifts![j].exerciseId, exercises.isNotEmpty ? exercises.where((element) => element.id == calendarWorkouts[i].lifts![j].exerciseId).first.bodyPart : "", calendarWorkouts[i].lifts![j].liftMas!.toInt(), calendarWorkouts[i].lifts![j].repetitions ?? 0, calendarWorkouts[i].lifts![j].oneRepMax ?? 0.0, true, -1));
          }
        }
      }
    } else if (mode == 1) {
      print(workOuts.length);
      var workout = workOuts.where((element) => element.id == id).single;

      print(workout.title);
      for (int j = 0; j < workout.lifts!.length; j++) {
        title = workout.title ?? "";
        lifts.add(EditableLift.create(workout.lifts![j].exerciseName, workout.lifts![j].exerciseId, exercises.isNotEmpty ? exercises.where((element) => element.id == workout.lifts![j].exerciseId).first.bodyPart : "", workout.lifts![j].liftMas!.toInt(), workout.lifts![j].repetitions ?? 0, workout.lifts![j].oneRepMax ?? 0.0, true, -1));
      }
    } else if (mode == 3) {
      var workout = favoriteWorkOuts.where((element) => element.id == id).single;
      for (int j = 0; j < workout.lifts!.length; j++) {
        title = workout.title ?? "";
        lifts.add(EditableLift.create(workout.lifts![j].exerciseName, workout.lifts![j].exerciseId, exercises.isNotEmpty ? exercises.where((element) => element.id == workout.lifts![j].exerciseId).first.bodyPart : "", workout.lifts![j].liftMas!.toInt(), workout.lifts![j].repetitions ?? 0, workout.lifts![j].oneRepMax ?? 0.0, true, -1));
      }
    }

    await createWorkoutProvider.repeatWorkoutSession(lifts, title ?? "[]");
  }

  void _updateWorkoutFavoriteStatus(int id, int mode) {
    if (mode == 1)
      for (int i = 0; i < workOuts.length; i++) {
        if (workOuts[i].id == id) {
          workOuts[i].isFavorite = !workOuts[i].isFavorite;
          if (calendarWorkouts.isNotEmpty) calendarWorkouts.where((element) => element.id == id).first.isFavorite = workOuts[i].isFavorite;

          if (workOuts[i].isFavorite && requestDone2) {
            favoriteWorkOuts.add(workOuts[i]);
          } else {
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
            favoriteWorkOuts.add(calendarWorkouts[i]);
          } else {
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
    else if (mode == 3) {
      print("dferqerig");
      for (int i = 0; i < favoriteWorkOuts.length; i++) {
        print(favoriteWorkOuts[i].id);
      }

      favoriteWorkOuts.removeWhere((element) => element.id == id);
      if (requestDone1) {
        for (int i = 0; i < workOuts.length; i++) {
          if (workOuts[i].id == id) {
            workOuts[i].isFavorite = false;
          }
        }
      }
      if (requestDone3) calendarWorkouts.singleWhere((element) => element.id == id).isFavorite = false;
    }

    notifyListeners();
  }

  void reset() {
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


  void onCalendarPageRefereshed(DateTime  dateTime){
    selectedDate = dateTime;
     currentMonthIndex =  dateTime.month - 1;;
     update();
  }

  void update() {
    notifyListeners();
  }
//endregion
}
